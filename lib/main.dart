import 'package:flutter/material.dart';
import 'package:uas_pmob/AppDosen.dart';

void main() {
  runApp(
    HomeApp(),
  );
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppDosen(),
    );
  }
}
