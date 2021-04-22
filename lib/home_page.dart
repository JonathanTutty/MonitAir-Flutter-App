import 'package:air_pollution/constants.dart';
import 'package:air_pollution/flutter_connect.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'create_csv.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 32.0,
              child: Image.asset('images/monitair.png', fit: BoxFit.fitHeight),
            ),
            SizedBox(width: 32.0,),
            Text(
              "MONITAIR",
              style: appTitleStyle,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: LiveData()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                child: Text(
                  'Export Historical Data to CSV',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  primary: primaryColour,
                  backgroundColor: primaryColourLight,
                  elevation: 3.0,
                  shape: StadiumBorder(),
                  side: BorderSide(
                    color: primaryColour,
                    width: 2.0,
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return MyDialogue();
                      });
                }),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
