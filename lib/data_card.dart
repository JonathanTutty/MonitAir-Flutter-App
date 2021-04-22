import 'package:flutter/material.dart';
import 'constants.dart';

class DataCard extends StatelessWidget {
  DataCard({@required this.title, @required this.data, this.unit = ''});

  final String title;
  final String data;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              title,
              style: subheadingStyle,
            ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    data,
                    style: dataTextStyle,
                  ),
                  Text(
                    unit,
                    style: subheadingStyle,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        // border: Border.all(color: Colors.lightBlue, width: 1.0),
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
    );
  }
}
