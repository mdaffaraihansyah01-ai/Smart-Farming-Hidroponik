import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient createMqttClientImpl(String broker, String clientId) =>
    MqttBrowserClient('ws://$broker/mqtt', clientId);
