import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClientImpl(String broker, String clientId) =>
    MqttServerClient.withPort(broker, clientId, 1883)..secure = false;
