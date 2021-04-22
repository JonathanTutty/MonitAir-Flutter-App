import 'package:flutter/material.dart';
import 'constants.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AirMonitor());
}

class AirMonitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primaryColor: primaryColour,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


