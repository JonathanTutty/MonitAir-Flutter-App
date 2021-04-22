import 'package:air_pollution/data_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charcode/charcode.dart';
import 'info_card.dart';
import 'constants.dart';

class LiveData extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return AirQualityData();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class AirQualityData extends StatefulWidget {
  @override
  _AirQualityDataState createState() => _AirQualityDataState();
}

class _AirQualityDataState extends State<AirQualityData> {
  final databaseReference = FirebaseDatabase.instance.reference();

  // Doubles to store data
  String breathVoc = '';
  String co2 = '';
  String humidity = '';
  String iaq = '';
  String pressure = '';
  String temperature = '';
  String smoke = '';

  // Widgets to store info cards
  Widget bVocCard;
  Widget co2Card;
  Widget humCard;
  Widget iaqCard;
  Widget presCard;
  Widget tempCard;
  Widget smokeCard;

  // Character for degrees celcius
  String deg = String.fromCharCode($deg);

  Table iaqInfo = Table(
    border: TableBorder.all(color: Colors.white),
    children: <TableRow>[
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                'IAQ Index',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                'Air Quality',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.green,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('0 - 50'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('Good'),
            ),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.yellow,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('51 - 100'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('Average'),
            ),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.orange,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('101 - 150'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('Quite Bad'),
            ),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('151 - 200'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text('Bad'),
            ),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.purple,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '201 - 300',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                'Worse',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '301 - 500',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                'Very Bad',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: databaseReference.onValue,
          builder: (context, snapshot) {
            List<Widget> children;

            if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  children = <Widget>[
                    SizedBox(
                      child: const CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Connecting...'),
                    )
                  ];
                  break;
                default:
                  databaseReference
                      .child('Breath VOC')
                      .orderByKey()
                      .limitToLast(1)
                      .once()
                      .then((DataSnapshot snapshot) {
                    String data = snapshot.value.toString();
                    breathVoc = data2dp(data);
                  });

                  databaseReference
                      .child('CO2')
                      .orderByKey()
                      .limitToLast(1)
                      .once()
                      .then((DataSnapshot snapshot) {
                    String data = snapshot.value.toString();
                    co2 = data0dp(data);
                  });

                  databaseReference
                      .child('Humidity')
                      .orderByKey()
                      .limitToLast(1)
                      .once()
                      .then((DataSnapshot snapshot) {
                    String data = snapshot.value.toString();
                    humidity = data1dp(data);
                  });

                  databaseReference
                      .child('IAQ')
                      .orderByKey()
                      .limitToLast(1)
                      .once()
                      .then((DataSnapshot snapshot) {
                    String data = snapshot.value.toString();
                    iaq = data0dp(data);
                  });

                  databaseReference
                      .child('Pressure')
                      .orderByKey()
                      .limitToLast(1)
                      .once()
                      .then((DataSnapshot snapshot) {
                    String data = snapshot.value.toString();
                    pressure = data1dp(data);
                  });

                  databaseReference
                      .child('Temperature')
                      .orderByKey()
                      .limitToLast(1)
                      .once()
                      .then((DataSnapshot snapshot) {
                    String data = snapshot.value.toString();
                    temperature = data1dp(data);
                  });

                  databaseReference
                      .child('Smoke Detection')
                      .orderByKey()
                      .limitToLast(1)
                      .once()
                      .then((DataSnapshot snapshot) {
                    String data = snapshot.value.toString();
                    smoke = data0dp(data);
                  });

                  // Query snapshot = databaseReference.child('Temperature').orderByKey().limitToLast(1);
                  //   temperature = snapshot.ge;

                  if (breathVoc.isEmpty) {
                    bVocCard = DataCard(title: 'Breath VOC', data: "No data");
                  } else {
                    bVocCard = DataCard(
                      title: 'Breath VOC',
                      data: breathVoc,
                      unit: ' ppm',
                    );
                  }

                  if (co2.isEmpty) {
                    co2Card = DataCard(title: 'CO\u2082', data: 'No data');
                  } else {
                    co2Card = DataCard(
                      title: 'CO\u2082',
                      data: co2,
                      unit: ' ppm',
                    );
                  }

                  if (humidity.isEmpty) {
                    humCard = DataCard(title: 'Humidity', data: 'No data');
                  } else {
                    humCard = DataCard(
                      title: 'Humidity',
                      data: humidity,
                      unit: ' % R.H.',
                    );
                  }

                  if (iaq.isEmpty) {
                    iaqCard = InfoCard(
                      title: 'IAQ',
                      data: 'No data',
                      dialogueTitle: 'Indoor Air Quality (IAQ)',
                      dialogueContent: iaqInfo,
                    );
                  } else {
                    iaqCard = InfoCard(
                      title: 'IAQ',
                      data: iaq,
                      dialogueTitle: 'Indoor Air Quality (IAQ)',
                      dialogueContent: iaqInfo,
                    );
                  }

                  if (pressure.isEmpty) {
                    presCard = DataCard(title: 'Pressure', data: 'No data');
                  } else {
                    presCard = DataCard(
                      title: 'Pressure',
                      data: pressure,
                      unit: ' hPa',
                    );
                  }

                  if (temperature.isEmpty) {
                    tempCard = DataCard(title: 'Temperature', data: 'No data');
                  } else {
                    tempCard = DataCard(
                      title: 'Temperature',
                      data: temperature,
                      unit: ' ${deg}C',
                    );
                  }

                  if (smoke.isEmpty) {
                    smokeCard = DataCard(title: 'Smoke', data: 'No data');
                  } else {
                    if (smoke.compareTo('1') == 0) {
                      smokeCard = DataCard(title: 'Smoke', data: 'No smoke detected');
                    } else {
                      smokeCard = DataCard(title: 'Smoke', data: 'Smoke detected!');
                    }
                  }

                  children = <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: bVocCard),
                          Expanded(child: co2Card),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: humCard),
                          Expanded(child: iaqCard),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: presCard),
                          Expanded(child: tempCard),
                        ],
                      ),
                    ),
                    Expanded(child: smokeCard),
                  ];
              }
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          }),
    );
  }

  String data2dp(String data) {
    int start = data.indexOf('data: ');
    int end = data.indexOf('}');
    String dataNum = data.substring(start + 6, end);

    int dp = dataNum.indexOf('.');
    if (dp != -1) {
      // dataNum = dataNum.substring(0, dp + 3);
      double num = double.parse(dataNum);
      dataNum = num.toStringAsFixed(2);
    }
    return dataNum;
  }

  String data1dp(String data) {
    int start = data.indexOf('data: ');
    int end = data.indexOf('}');
    String dataNum = data.substring(start + 6, end);

    int dp = dataNum.indexOf('.');
    if (dp != -1) {
      // dataNum = dataNum.substring(0, dp + 3);
      double num = double.parse(dataNum);
      dataNum = num.toStringAsFixed(1);
    }
    return dataNum;
  }

  String data0dp(String data) {
    int start = data.indexOf('data: ');
    int end = data.indexOf('}');
    String dataNum = data.substring(start + 6, end);

    int dp = dataNum.indexOf('.');
    if (dp != -1) {
      // dataNum = dataNum.substring(0, dp + 3);
      double num = double.parse(dataNum);
      dataNum = num.toStringAsFixed(0);
    }
    return dataNum;
  }
}

class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Something Went Wrong"),
    );
  }
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
