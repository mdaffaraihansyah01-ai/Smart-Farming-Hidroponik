import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text("Full Analytics", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1B5E20),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("Air Monitoring (Udara)"),
          _buildChartCard("Air Temperature (°C)", _generateMockSpots(25, 32), Colors.orange),
          const SizedBox(height: 16),
          _buildChartCard("Air Humidity (%)", _generateMockSpots(60, 70), Colors.blue),
          const SizedBox(height: 16),
          _buildChartCard("Light Intensity (Lux)", _generateMockSpots(300, 600), Colors.amber),
          
          const SizedBox(height: 32),
          _buildSectionHeader("Water Monitoring (Air)"),
          _buildChartCard("Water Temperature (°C)", _generateMockSpots(22, 26), Colors.cyan),
          const SizedBox(height: 16),
          _buildChartCard("Water Level (cm)", _generateMockSpots(70, 90), Colors.blueAccent),
          const SizedBox(height: 16),
          _buildChartCard("Water pH", _generateMockSpots(6.5, 7.5), Colors.purple),
          const SizedBox(height: 16),
          _buildChartCard("Water TDS (PPM)", _generateMockSpots(400, 500), Colors.indigo),

          const SizedBox(height: 32),
          _buildSectionHeader("Soil Monitoring (Tanah)"),
          _buildChartCard("Soil Moisture (%)", _generateMockSpots(35, 55), Colors.brown),
          const SizedBox(height: 16),
          _buildChartCard("Soil pH", _generateMockSpots(6.0, 7.0), Colors.teal),
          const SizedBox(height: 16),
          _buildChartCard("NPK Levels (mg/kg)", _generateMockSpots(100, 200), Colors.green),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
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
