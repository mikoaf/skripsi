import 'package:aplikasi_ekg/home.dart';
import 'package:aplikasi_ekg/pages/bth_after.dart';
import 'package:aplikasi_ekg/pages/bth_before.dart';
import 'package:aplikasi_ekg/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: Home_Page());
  }
}
