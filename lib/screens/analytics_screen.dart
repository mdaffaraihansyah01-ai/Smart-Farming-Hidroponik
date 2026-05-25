import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: CustomScrollView(
        slivers: [
          _buildCustomAppBar(context, isWideScreen),
          SliverToBoxAdapter(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 48 : 24,
                vertical: 24,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSectionHeader("Monitoring Udara"),
                _buildChartCard(
                  "Suhu Udara (°C)",
                  _generateMockSpots(25, 32),
                  Colors.orange,
                ),
                const SizedBox(height: 20),
                _buildChartCard(
                  "Kelembaban Udara (%)",
                  _generateMockSpots(60, 70),
                  Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildChartCard(
                  "Intensitas Cahaya (Lux)",
                  _generateMockSpots(300, 600),
                  Colors.amber,
                ),
                const SizedBox(height: 40),
                _buildSectionHeader("Monitoring Air"),
                _buildChartCard(
                  "Suhu Air (°C)",
                  _generateMockSpots(22, 26),
                  Colors.cyan,
                ),
                const SizedBox(height: 20),
                _buildChartCard(
                  "Level Air (cm)",
                  _generateMockSpots(70, 90),
                  Colors.blueAccent,
                ),
                const SizedBox(height: 20),
                _buildChartCard(
                  "pH Air",
                  _generateMockSpots(6.5, 7.5),
                  Colors.purple,
                ),
                const SizedBox(height: 20),
                _buildChartCard(
                  "TDS Air (PPM)",
                  _generateMockSpots(400, 500),
                  Colors.indigo,
                ),
                const SizedBox(height: 40),
                _buildSectionHeader("Monitoring Tanah"),
                _buildChartCard(
                  "Kelembaban Tanah (%)",
                  _generateMockSpots(35, 55),
                  Colors.brown,
                ),
                const SizedBox(height: 20),
                _buildChartCard(
                  "pH Tanah",
                  _generateMockSpots(6.0, 7.0),
                  Colors.teal,
                ),
                const SizedBox(height: 20),
                _buildChartCard(
                  "Level NPK (mg/kg)",
                  _generateMockSpots(100, 200),
                  Colors.green,
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, bool isWideScreen) {
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
          child: Row(
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
                      'Analisis Sensor',
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
                tooltip: 'Kembali',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2E7D32),
        ),
      ),
    );
  }

  List<FlSpot> _generateMockSpots(double min, double max) {
    return [
      FlSpot(0, min + (max - min) * 0.2),
      FlSpot(2, min + (max - min) * 0.5),
      FlSpot(4, min + (max - min) * 0.3),
      FlSpot(6, min + (max - min) * 0.8),
      FlSpot(8, min + (max - min) * 0.6),
      FlSpot(10, min + (max - min) * 0.9),
    ];
  }

  Widget _buildChartCard(String title, List<FlSpot> spots, Color color) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      (spots.reduce((a, b) => a.y > b.y ? a : b).y -
                          spots.reduce((a, b) => a.y < b.y ? a : b).y) /
                      4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.15),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    left: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: color,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
