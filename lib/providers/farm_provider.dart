import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/actuator_state.dart';
import '../models/sensor_reading.dart';
import '../services/mqtt_service.dart';

class FarmProvider with ChangeNotifier {
  SensorReading _reading = SensorReading.mock();
  final ActuatorState _actuators = ActuatorState();
  MqttService? _mqttService;
  bool _mqttConnected = false;

  static const String _mqttBroker = 'broker.emqx.io';
  static const String _topicPublish = 'smartfarming/kontrol/perintah';
  static const String _topicSubscribe = 'smartfarming/sensor/data';

  SensorReading get reading => _reading;
  ActuatorState get actuators => _actuators;
  bool get mqttConnected => _mqttConnected;

  Future<void> initMqtt() async {
    if (_mqttService != null) return;

    _mqttService = MqttService(
      broker: _mqttBroker,
      publishTopic: _topicPublish,
      subscribeTopic: _topicSubscribe,
      onMessage: _handleIncomingMqtt,
    );

    final success = await _mqttService!.connect();
    _mqttConnected = success;
    notifyListeners();
  }

  void updateSensors(SensorReading newReading) {
    _reading = newReading;
    notifyListeners();
  }

  void _handleIncomingMqtt(String topic, String payload) {
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      _reading = SensorReading(
        airTemp: _parseDouble(map['suhu_udara'], _reading.airTemp),
        airHumidity: _parseDouble(map['kelembapan_udara'], _reading.airHumidity),
        lightIntensity: _parseDouble(map['intensitas_cahaya'], _reading.lightIntensity),
        waterTemp: _parseDouble(map['suhu_air'], _reading.waterTemp),
        waterLevel: _parseDouble(map['status_air'], _reading.waterLevel),
        waterPh: _parseDouble(map['ph_air'], _reading.waterPh),
        waterTds: _reading.waterTds,
        soilMoisture: _parseDouble(map['kelembapan_tanah'], _reading.soilMoisture),
        soilPh: _parseDouble(map['soil_ph'] ?? map['soilPh'] ?? map['ph_air'], _reading.soilPh),
        nitrogen: _reading.nitrogen,
        phosphorus: _reading.phosphorus,
        potassium: _reading.potassium,
      );
      notifyListeners();
    } catch (error) {
      debugPrint('Failed to decode MQTT payload: $error');
    }
  }

  double _parseDouble(dynamic value, double fallback) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      return parsed ?? fallback;
    }
    return fallback;
  }

  void _publishControlState() {
    if (_mqttService == null || !_mqttConnected) return;

    final payload = jsonEncode({
      'pump': _actuators.pump,
      'fan': _actuators.fan,
      'buzzer': _actuators.buzzer,
      'led_red': _actuators.ledRed,
      'led_yellow': _actuators.ledYellow,
      'led_green': _actuators.ledGreen,
    });

    _mqttService!.publishCommand(payload);
  }

  void togglePump() {
    _actuators.pump = !_actuators.pump;
    _publishControlState();
    notifyListeners();
  }

  void toggleFan() {
    _actuators.fan = !_actuators.fan;
    _publishControlState();
    notifyListeners();
  }

  void toggleBuzzer() {
    _actuators.buzzer = !_actuators.buzzer;
    _publishControlState();
    notifyListeners();
  }

  void setLedRed(bool value) {
    _actuators.ledRed = value;
    _publishControlState();
    notifyListeners();
  }

  void setLedYellow(bool value) {
    _actuators.ledYellow = value;
    _publishControlState();
    notifyListeners();
  }

  void setLedGreen(bool value) {
    _actuators.ledGreen = value;
    _publishControlState();
    notifyListeners();
  }
}
