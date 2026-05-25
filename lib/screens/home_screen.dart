import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/farm_provider.dart';
import '../widgets/sensor_tile.dart';
import '../widgets/actuator_control.dart';
import '../screens/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmProvider>().initMqtt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(child: SizedBox(height: 12)),
            if (_selectedIndex == 0) ..._buildAirDashboard(context),
            if (_selectedIndex == 1) ..._buildWaterDashboard(context),
            if (_selectedIndex == 2) ..._buildSoilDashboard(context),
            if (_selectedIndex == 3) ..._buildControlDashboard(context),
            SliverToBoxAdapter(child: SizedBox(height: 40)),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Aktuator',
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final mqttConnected = context.watch<FarmProvider>().mqttConnected;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1024;

    String subtitle = "";
    switch (_selectedIndex) {
      case 0:
        subtitle = "Monitoring Udara";
        break;
      case 1:
        subtitle = "Monitoring Air";
        break;
      case 2:
        subtitle = "Monitoring Tanah";
        break;
      case 3:
        subtitle = "Kontrol Aktuator";
        break;
    }

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWideScreen ? 32 : 20,
            vertical: isWideScreen ? 20 : 16,
          ),
          child: Column(
            children: [
              // Header dengan logo dan institusi
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/LOGO POLINES.png',
                      width: isWideScreen ? 80 : 60,
                      height: isWideScreen ? 80 : 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: isWideScreen ? 24 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Farming POLINES',
                          style: GoogleFonts.poppins(
                            fontSize: isWideScreen ? 24 : 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                        Text(
                          'Politeknik Negeri Semarang',
                          style: GoogleFonts.poppins(
                            fontSize: isWideScreen ? 14 : 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSensorGraphMenu(context),
                ],
              ),
              const SizedBox(height: 16),
              // Divider
              Container(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 16),
              // Subtitle dan status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: isWideScreen ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWideScreen)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: mqttConnected
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                mqttConnected
                                    ? Icons.cloud_done
                                    : Icons.cloud_off,
                                color: mqttConnected
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                mqttConnected
                                    ? 'MQTT Terhubung'
                                    : 'MQTT Terputus',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: mqttConnected
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: widget.onLogout,
                          icon: const Icon(
                            Icons.logout,
                            color: Color(0xFF2E7D32),
                            size: 24,
                          ),
                          tooltip: 'Logout',
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFF2E7D32),
                          child: Text(
                            'U',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorGraphMenu(BuildContext context) {
    return PopupMenuButton<int>(
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.show_chart, color: Color(0xFF2E7D32), size: 28),
      tooltip: 'Lihat Grafik Sensor',
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.air, color: Colors.orange, size: 20),
              SizedBox(width: 12),
              Text('Grafik Udara'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.water, color: Colors.blue, size: 20),
              SizedBox(width: 12),
              Text('Grafik Air'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.grass, color: Colors.brown, size: 20),
              SizedBox(width: 12),
              Text('Grafik Tanah'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<int>(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.analytics, color: Colors.purple, size: 20),
              SizedBox(width: 12),
              Text('Analisis Lengkap'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 3) {
          // Navigate to full analytics
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
          );
        } else {
          // Switch to the selected tab
          setState(() => _selectedIndex = value);
        }
      },
    );
  }

  List<Widget> _buildAirDashboard(BuildContext context) {
    final reading = context.watch<FarmProvider>().reading;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossCount = screenWidth > 1200
        ? 4
        : screenWidth > 900
        ? 3
        : screenWidth > 600
        ? 2
        : 1;

    return [
      _buildSectionSliver("Monitoring Udara"),
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 900 ? 32.0 : 20.0,
        ),
        sliver: SliverGrid.count(
          crossAxisCount: crossCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.6,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossCount = screenWidth > 1200
        ? 4
        : screenWidth > 900
        ? 3
        : screenWidth > 600
        ? 2
        : 1;

    return [
      _buildSectionSliver("Monitoring Air"),
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 900 ? 32.0 : 20.0,
        ),
        sliver: SliverGrid.count(
          crossAxisCount: crossCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.6,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossCount = screenWidth > 1200
        ? 4
        : screenWidth > 900
        ? 3
        : screenWidth > 600
        ? 2
        : 1;

    return [
      _buildSectionSliver("Monitoring Tanah"),
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 900 ? 32.0 : 20.0,
        ),
        sliver: SliverGrid.count(
          crossAxisCount: crossCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.6,
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
              value:
                  "${reading.nitrogen.toInt()}-${reading.phosphorus.toInt()}-${reading.potassium.toInt()}",
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossCount = screenWidth > 900 ? 3 : 1;

    return [
      _buildSectionSliver("Kontrol Aktuator"),
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 900 ? 32.0 : 20.0,
        ),
        sliver: SliverGrid.count(
          crossAxisCount: crossCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
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
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 12),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B5E20),
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
          _ledIndicator(
            "Red",
            actuators.ledRed,
            Colors.red,
            (v) => provider.setLedRed(v),
          ),
          _ledIndicator(
            "Yellow",
            actuators.ledYellow,
            Colors.yellow,
            (v) => provider.setLedYellow(v),
          ),
          _ledIndicator(
            "Green",
            actuators.ledGreen,
            Colors.green,
            (v) => provider.setLedGreen(v),
          ),
        ],
      ),
    );
  }

  Widget _ledIndicator(
    String label,
    bool isOn,
    Color color,
    ValueChanged<bool> onTap,
  ) {
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
              boxShadow: isOn
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
