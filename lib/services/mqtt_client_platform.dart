import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt_client_platform_io.dart'
    if (dart.library.html) 'mqtt_client_platform_web.dart';

MqttClient createMqttClient(String broker, String clientId) =>
    createMqttClientImpl(broker, clientId);
