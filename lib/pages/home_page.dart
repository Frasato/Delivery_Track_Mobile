import 'dart:async';
import 'dart:io';
import 'package:delivery_track_app/services/api_service.dart';
import 'package:delivery_track_app/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  
  final WebsocketService _websocketService = WebsocketService();
  String? _deliveryId;
  bool _sendingLocation = false;
  String? _trackingUrl;

  void _startDelivery() async{
    final token = await ApiService.getToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if(token == null || userId == null) return;

    final link = await ApiService.startDelivery(token, userId);
    if(link != null){
      final id = Uri.parse(link).pathSegments.last;

      final url = 'http://localhost:5173/track/$id';

      setState(() {
        _deliveryId = id;
        _sendingLocation = true;
        _trackingUrl = url;
      });

      _websocketService.connect(id);
    }
  }

  void _endDelivery() async{
    final token = await ApiService.getToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if(token == null || userId == null) return;

    bool success = await ApiService.endDelivery(token, _deliveryId, userId);
    if(success){
      _websocketService.disconnect();
      setState(() {
        _sendingLocation = false;
        _deliveryId = null;
      });
    }
  }

  @override
  initState(){
    super.initState();
    startListeningLocation();
  }

  Position? currentLocation;
  StreamSubscription? subscription;
  
  locationPermission({VoidCallback? isSuccess}) async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        await Geolocator.openAppSettings();
      }
    }

    if(permission == LocationPermission.deniedForever){
      await Geolocator.openAppSettings();
      return Future.error('Location permissions are permanetly denied, we cannot request permissions.');
    }
    {
      isSuccess?.call();
    }
  }

  void startListeningLocation(){
    locationPermission(
      isSuccess: () async{
        subscription = Geolocator.getPositionStream(
          locationSettings: Platform.isAndroid 
            ? AndroidSettings(
              foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationTitle: 'Location fetching in background',
                notificationText: 'Your current location is listened in background',
                enableWakeLock: true,
              ),
            )
            : AppleSettings(
              accuracy: LocationAccuracy.high,
              activityType: ActivityType.fitness,
              pauseLocationUpdatesAutomatically: true,
              showBackgroundLocationIndicator: false,
            )
        ).listen((event) async{
          currentLocation = event;
          _websocketService.sendLocation(currentLocation?.latitude, currentLocation?.longitude);
        });
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Home'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _startDelivery,
              child: const Text('Iniciar Corrida')
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _endDelivery,
              child: const Text('Encerrar Corrida')
            ),
            const SizedBox(height: 24),
            Text(
              _sendingLocation ? 'Enviando localização...' : 'Parado.'
            ),
            if(_trackingUrl != null) ...[
              SelectableText(
                'Link de rastreamento: \n$_trackingUrl',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _trackingUrl!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copiado!'))
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copiar Link'),
              )
            ]
          ],
        ),
      ),
    );
    }
    @override
    void dispose(){
      subscription?.cancel();
      super.dispose();
  }
}