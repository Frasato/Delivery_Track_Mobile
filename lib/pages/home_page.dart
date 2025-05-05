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
      _startLocationUpdates();
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

  void _startLocationUpdates() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) return;

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, //Se for 10, a cada 10 metros ele vai chamar o getPosition, para testes parados, deixe 0
      ),
    ).listen((Position position) {
      if(_sendingLocation){
        _websocketService.sendLocation(position.latitude, position.longitude);
      }
    });
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
}