import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/farm_provider.dart';
import '../widgets/sensor_tile.dart';
import '../widgets/actuator_control.dart';
import '../screens/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            if (_selectedIndex == 0) ..._buildAirDashboard(context),
            if (_selectedIndex == 1) ..._buildWaterDashboard(context),
            if (_selectedIndex == 2) ..._buildSoilDashboard(context),
            if (_selectedIndex == 3) ..._buildControlDashboard(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.air), label: 'Udara'),
          BottomNavigationBarItem(icon: Icon(Icons.water), label: 'Air'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Tanah'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Aktuator'),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    String subtitle = "";
    switch (_selectedIndex) {
      case 0: subtitle = "Air Monitoring (Udara)"; break;
      case 1: subtitle = "Water Monitoring (Air)"; break;
      case 2: subtitle = "Soil Monitoring (Tanah)"; break;
      case 3: subtitle = "Controls & Actuators"; break;
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Smart Farming",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
                    );
                  },
                  icon: const Icon(Icons.bar_chart, color: Color(0xFF2E7D32), size: 28),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF2E7D32),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAirDashboard(BuildContext context) {
    final reading = context.watch<FarmProvider>().reading;
    return [
      _buildSectionSliver("Air Monitoring (Udara)"),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        sliver: SliverGrid.count(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            SensorTile(
              label: "Temperature",
              value: reading.airTemp.toStringAsFixed(1),
              unit: "°C",
              icon: Icons.thermostat,
              color: Colors.orange,
            ),
            SensorTile(
              label: "Humidity",
              value: reading.airHumidity.toStringAsFixed(1),
              unit: "%",
              icon: Icons.water_drop,
              color: Colors.blue,
            ),
            SensorTile(
              label: "Light Intensity",
              value: reading.lightIntensity.toStringAsFixed(0),
              unit: "Lux",
              icon: Icons.light_mode,
              color: Colors.amber,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildWaterDashboard(BuildContext context) {
    final reading = context.watch<FarmProvider>().reading;
    return [
      _buildSectionSliver("Water Monitoring (Air)"),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        sliver: SliverGrid.count(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            SensorTile(
              label: "Water Temp",
              value: reading.waterTemp.toStringAsFixed(1),
              unit: "°C",
              icon: Icons.device_thermostat,
              color: Colors.cyan,
            ),
            SensorTile(
              label: "Water Level",
              value: reading.waterLevel.toStringAsFixed(0),
              unit: "cm",
              icon: Icons.waves,
              color: Colors.blueAccent,
            ),
            SensorTile(
              label: "Water pH",
              value: reading.waterPh.toStringAsFixed(1),
              unit: "pH",
              icon: Icons.science,
              color: Colors.purple,
            ),
            SensorTile(
              label: "Water TDS",
              value: reading.waterTds.toStringAsFixed(0),
              unit: "PPM",
              icon: Icons.opacity,
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildSoilDashboard(BuildContext context) {
    final reading = context.watch<FarmProvider>().reading;
    return [
      _buildSectionSliver("Soil Monitoring (Tanah)"),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        sliver: SliverGrid.count(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            SensorTile(
              label: "Soil Moisture",
              value: reading.soilMoisture.toStringAsFixed(1),
              unit: "%",
              icon: Icons.grass,
              color: Colors.brown,
            ),
            SensorTile(
              label: "Soil pH",
              value: reading.soilPh.toStringAsFixed(1),
              unit: "pH",
              icon: Icons.biotech,
              color: Colors.teal,
            ),
            SensorTile(
              label: "Soil NPK",
              value: "${reading.nitrogen.toInt()}-${reading.phosphorus.toInt()}-${reading.potassium.toInt()}",
              unit: "mg/kg",
              icon: Icons.eco,
              color: Colors.green,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildControlDashboard(BuildContext context) {
    final provider = context.watch<FarmProvider>();
    final actuators = provider.actuators;
    return [
      _buildSectionSliver("Controls & Actuators"),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        sliver: SliverGrid.count(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 4,
          children: [
            ActuatorControl(
              label: "Water Pump",
              value: actuators.pump,
              icon: Icons.water_damage,
              activeColor: Colors.blue,
              onChanged: (_) => provider.togglePump(),
            ),
            ActuatorControl(
              label: "DC Fan",
              value: actuators.fan,
              icon: Icons.air,
              activeColor: Colors.cyan,
              onChanged: (_) => provider.toggleFan(),
            ),
            ActuatorControl(
              label: "Alarm Buzzer",
              value: actuators.buzzer,
              icon: Icons.notifications_active,
              activeColor: Colors.red,
              onChanged: (_) => provider.toggleBuzzer(),
            ),
            _buildLedControls(provider),
          ],
        ),
      ),
    ];
  }

  Widget _buildSectionSliver(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildLedControls(FarmProvider provider) {
    final actuators = provider.actuators;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ledIndicator("Red", actuators.ledRed, Colors.red, (v) => provider.setLedRed(v)),
          _ledIndicator("Yellow", actuators.ledYellow, Colors.yellow, (v) => provider.setLedYellow(v)),
          _ledIndicator("Green", actuators.ledGreen, Colors.green, (v) => provider.setLedGreen(v)),
        ],
      ),
    );
  }

  Widget _ledIndicator(String label, bool isOn, Color color, ValueChanged<bool> onTap) {
    return GestureDetector(
      onTap: () => onTap(!isOn),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOn ? color : color.withValues(alpha: 0.2),
              boxShadow: isOn ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)] : null,
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
