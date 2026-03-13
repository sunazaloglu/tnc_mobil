import 'package:flutter/material.dart';
import 'package:tnc_mobil/views/home_screen.dart';

// Uygulamayı ayağa kaldıran ana fonksiyon.
void main() {
  runApp(const MyApp());
}

// Uygulamanın kök widget'ı ve tema ayarları.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.white)),
      home: HomeScreen(),
    );
  }
}
