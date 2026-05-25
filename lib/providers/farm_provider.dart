import 'package:flutter/foundation.dart';
import '../models/sensor_reading.dart';
import '../models/actuator_state.dart';

class FarmProvider with ChangeNotifier {
  SensorReading _reading = SensorReading.mock();
  final ActuatorState _actuators = ActuatorState();

  SensorReading get reading => _reading;
  ActuatorState get actuators => _actuators;

  void updateSensors(SensorReading newReading) {
    _reading = newReading;
    notifyListeners();
  }

  void togglePump() {
    _actuators.pump = !_actuators.pump;
    notifyListeners();
  }

  void toggleFan() {
    _actuators.fan = !_actuators.fan;
    notifyListeners();
  }

  void toggleBuzzer() {
    _actuators.buzzer = !_actuators.buzzer;
    notifyListeners();
  }

  void setLedRed(bool value) {
    _actuators.ledRed = value;
    notifyListeners();
  }

  void setLedYellow(bool value) {
    _actuators.ledYellow = value;
    notifyListeners();
  }

  void setLedGreen(bool value) {
    _actuators.ledGreen = value;
    notifyListeners();
  }
}
