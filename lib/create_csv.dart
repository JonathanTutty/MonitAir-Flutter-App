import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';
import 'package:csv/csv.dart';
import 'package:ext_storage/ext_storage.dart';

final databaseReference = FirebaseDatabase.instance.reference();

Future<List<String>> getBreathVOC() async {
  List<String> breathVoc = [];

  return databaseReference
      .child('Breath VOC')
      .orderByKey()
      .once()
      .then((DataSnapshot snapshot) {
    for (var val in snapshot.value.entries) {
      String tempStr = getData(val.value.toString());
      if (tempStr.isNotEmpty) {
        breathVoc.add(tempStr);
      }
    }
    return breathVoc;
  });
}

Future<List<String>> getCo2() async {
  List<String> co2 = [];

  return databaseReference
      .child('CO2')
      .orderByKey()
      .once()
      .then((DataSnapshot snapshot) {
    for (var val in snapshot.value.entries) {
      String tempStr = getData(val.value.toString());
      if (tempStr.isNotEmpty) {
        co2.add(tempStr);
      }
    }
    return co2;
  });
}

Future<List<String>> getHumidity() async {
  List<String> humidity = [];

  return databaseReference
      .child('Humidity')
      .orderByKey()
      .once()
      .then((DataSnapshot snapshot) {
    for (var val in snapshot.value.entries) {
      String tempStr = getData(val.value.toString());
      if (tempStr.isNotEmpty) {
        humidity.add(tempStr);
      }
    }
    return humidity;
  });
}

Future<List<String>> getIaq() async {
  List<String> iaq = [];

  return databaseReference
      .child('IAQ')
      .orderByKey()
      .once()
      .then((DataSnapshot snapshot) {
    for (var val in snapshot.value.entries) {
      String tempStr = getData(val.value.toString());
      if (tempStr.isNotEmpty) {
        iaq.add(tempStr);
      }
    }
    return iaq;
  });
}

Future<List<String>> getPressure() async {
  List<String> pressure = [];

  return databaseReference
      .child('Pressure')
      .orderByKey()
      .once()
      .then((DataSnapshot snapshot) {
    for (var val in snapshot.value.entries) {
      String tempStr = getData(val.value.toString());
      if (tempStr.isNotEmpty) {
        pressure.add(tempStr);
      }
    }
    return pressure;
  });
}

Future<List<String>> getTemperature() async {
  List<String> temperature = [];

  return databaseReference
      .child('Temperature')
      .orderByKey()
      .once()
      .then((DataSnapshot snapshot) {
    for (var val in snapshot.value.entries) {
      String tempStr = getData(val.value.toString());
      if (tempStr.isNotEmpty) {
        temperature.add(tempStr);
      }
    }
    return temperature;
  });
}

String getData(String data) {
  String dataNum = '';
  int start = data.indexOf('data: ');
  int end = data.indexOf('}');
  if (start != -1 && end != -1) {
    dataNum = data.substring(start + 6, end);
  }
  return dataNum;
}

class MyDialogue extends StatefulWidget {
  @override
  _MyDialogueState createState() => new _MyDialogueState();
}

class _MyDialogueState extends State<MyDialogue> {
  List<Widget> children = [
    Text(
      'Do you want to export all historical data from the sensor as a .csv file?',
      style: subheadingStyle,
      textAlign: TextAlign.center,
    )
  ];

  List<String> breathVoc = [];
  List<String> co2 = [];
  List<String> humidity = [];
  List<String> iaq = [];
  List<String> pressure = [];
  List<String> temperature = [];

  bool gotData = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Export Data to CSV',
        style: dialogueTitleStyle,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 175.0,
        width: 250.0,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text('EXPORT'),
                  style: textButtonStyle,
                  onPressed: () {
                    exportToCsv();
                  },
                ),
                TextButton(
                  child: Text('CLOSE'),
                  style: textButtonStyle,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
    );
  }

  void exportToCsv() async {
    _showGettingData();

    try {
      breathVoc = await getBreathVOC();
      co2 = await getCo2();
      humidity = await getHumidity();
      iaq = await getIaq();
      pressure = await getPressure();
      temperature = await getTemperature();
    } catch (e) {
      _showFailed();
      gotData = false;
      print(e);
    }

    if (gotData) {
      breathVoc.insert(0, 'Breath VOC');
      co2.insert(0, 'C02');
      humidity.insert(0, 'Humidity');
      iaq.insert(0, 'IAQ');
      pressure.insert(0, 'Pressure');
      temperature.insert(0, 'Temperature');

      _showCreatingCsv();

      if (await Permission.storage.request().isGranted) {
        List<List<String>> historicalData = [
          breathVoc,
          co2,
          humidity,
          iaq,
          pressure,
          temperature
        ];
        String csv = const ListToCsvConverter().convert(historicalData);
        await writeString(csv);

        _showFinished();
      } else {
        _showFailed();
      }
    }
  }

  void _showGettingData() {
    setState(() {
      children = [
        CircularProgressIndicator(),
        SizedBox(height: 16.0),
        Text(
          'Getting data...',
          style: subheadingStyle,
        ),
      ];
    });
  }

  void _showCreatingCsv() {
    setState(() {
      children = [
        CircularProgressIndicator(),
        SizedBox(height: 16.0),
        Text(
          'Creating .csv file...',
          style: subheadingStyle,
        ),
      ];
    });
  }

  void _showFinished() {
    setState(() {
      children = [
        Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 50.0,
        ),
        SizedBox(height: 16.0),
        Text(
          'Done! historicalData.csv is now in your downloads.',
          style: subheadingStyle,
        ),
      ];
    });
  }

  void _showFailed() {
    setState(() {
      children = [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 50.0,
        ),
        SizedBox(height: 16.0),
        Text(
          'Failed to create file.',
          style: subheadingStyle,
        ),
      ];
    });
  }

  Future<String> get _localPath async {
    return await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/historicalData.csv');
  }

  Future<File> writeString(String csv) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(csv);
  }
}
