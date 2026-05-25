import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt_client_platform.dart';

typedef MqttMessageHandler = void Function(String topic, String payload);

class MqttService {
  final String broker;
  final String publishTopic;
  final String subscribeTopic;
  final String clientId;
  final MqttMessageHandler onMessage;
  late final MqttClient client;
  StreamSubscription? _subscription;

  MqttService({
    required this.broker,
    required this.publishTopic,
    required this.subscribeTopic,
    required this.onMessage,
  }) : clientId = 'flutter-sf-${DateTime.now().microsecondsSinceEpoch}' {
    client = _createClient();
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    client.onUnsubscribed = _onUnsubscribed;
    client.onSubscribeFail = _onSubscribeFail;
    client.pongCallback = _pong;
    client.autoReconnect = true;
  }

  MqttClient _createClient() {
    return createMqttClient(broker, clientId);
  }

  Future<bool> connect() async {
    try {
      client.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .withWillQos(MqttQos.atMostOnce);

      final connectionStatus = await client.connect();
      if (connectionStatus?.state == MqttConnectionState.connected) {
        _subscribe();
        _subscription = client.updates?.listen(_onMessageReceived);
        return true;
      }

      await disconnect();
      return false;
    } catch (error) {
      await disconnect();
      return false;
    }
  }

  void _subscribe() {
    client.subscribe(subscribeTopic, MqttQos.atMostOnce);
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>> events) {
    for (final event in events) {
      final payload = event.payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(
        payload.payload.message,
      );
      onMessage(event.topic, message);
    }
  }

  void publishCommand(String payloadJson) {
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(payloadJson);
    client.publishMessage(publishTopic, MqttQos.atMostOnce, builder.payload!);
  }

  Future<void> disconnect() async {
    client.disconnect();
    _subscription?.cancel();
    _subscription = null;
  }

  void _onConnected() {
    debugPrint('MQTT connected to $broker');
  }

  void _onDisconnected() {
    debugPrint('MQTT disconnected from $broker');
  }

  void _onSubscribed(String topic) {
    debugPrint('MQTT subscribed to $topic');
  }

  void _onUnsubscribed(String? topic) {
    debugPrint('MQTT unsubscribed from $topic');
  }

  void _onSubscribeFail(String topic) {
    debugPrint('MQTT subscribe failed: $topic');
  }

  void _pong() {
    debugPrint('MQTT ping response arrived');
  }
}
