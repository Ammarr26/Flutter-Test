import 'package:flutter/material.dart';
import 'package:math/pages/home_page.dart';

void main() {
  runApp(const IQMathApp());
}

class IQMathApp extends StatelessWidget {
  const IQMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IQ Math Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}