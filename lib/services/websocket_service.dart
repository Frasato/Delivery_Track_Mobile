import 'dart:convert';
import 'package:delivery_track_app/services/api_uri.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebsocketService {

  late StompClient _stompClient;
  String deliveryId = '';
  bool isConnected = false;

  void connect(String deliveryIdParam) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    
    deliveryId = deliveryIdParam;
  
    _stompClient = StompClient(
      config: StompConfig(
        url: webscoketUrl,
        onConnect: _onConnect,
        beforeConnect: () async {
          await Future.delayed(const Duration(microseconds: 200));
        },
        onWebSocketError: (error) => debugPrint('Error: $error'),
        stompConnectHeaders: {'Authorization' : 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization' : 'Bearer $token'}
      )
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame){
    isConnected = true;

    _stompClient.subscribe(
      destination: '/topic/location/$deliveryId',
      callback: (frame) => debugPrint('Recebido do servidor: $frame')
    );
  }

  void sendLocation(double? lat, double? lng){
    if(!isConnected) return;

    final body = jsonEncode({
      'deliveryId': deliveryId,
      'lat': lat,
      'lng': lng
    });

    _stompClient.send(
      destination: '/app/location',
      body: body,
    );
  }

  void disconnect(){
    _stompClient.deactivate();
    isConnected = false;
  }

}