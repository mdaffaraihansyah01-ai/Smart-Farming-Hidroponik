import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/farm_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FarmProvider()),
      ],
      child: const SmartFarmingApp(),
    ),
  );
}

class SmartFarmingApp extends StatefulWidget {
  const SmartFarmingApp({super.key});

  @override
  State<SmartFarmingApp> createState() => _SmartFarmingAppState();
}

class _SmartFarmingAppState extends State<SmartFarmingApp> {
  bool _isLoggedIn = false;

  void _login() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farming Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          surface: const Color(0xFFF1F8E9),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: _isLoggedIn 
          ? const HomeScreen() 
          : LoginScreen(onLoginSuccess: _login),
    );
  }
}
