import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActuatorControl extends StatelessWidget {
  final String label;
  final bool value;
  final IconData icon;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const ActuatorControl({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (value ? activeColor : Colors.grey).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: value ? activeColor : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: activeColor.withValues(alpha: 0.5),
            activeThumbColor: activeColor,
          ),
        ],
      ),
    );
  }
}
