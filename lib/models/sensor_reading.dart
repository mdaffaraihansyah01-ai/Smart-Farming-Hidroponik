class SensorReading {
  final double airTemp;
  final double airHumidity;
  final double lightIntensity;
  final double waterTemp;
  final double waterLevel;
  final double waterPh;
  final double waterTds;
  final double soilMoisture;
  final double soilPh;
  final double nitrogen;
  final double phosphorus;
  final double potassium;

  SensorReading({
    required this.airTemp,
    required this.airHumidity,
    required this.lightIntensity,
    required this.waterTemp,
    required this.waterLevel,
    required this.waterPh,
    required this.waterTds,
    required this.soilMoisture,
    required this.soilPh,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
  });

  factory SensorReading.mock() {
    return SensorReading(
      airTemp: 28.5,
      airHumidity: 65.0,
      lightIntensity: 450.0,
      waterTemp: 24.0,
      waterLevel: 80.0,
      waterPh: 7.2,
      waterTds: 450.0,
      soilMoisture: 45.0,
      soilPh: 6.5,
      nitrogen: 120.0,
      phosphorus: 80.0,
      potassium: 150.0,
    );
  }
}
