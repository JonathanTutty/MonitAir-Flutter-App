import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class InfoCard extends StatelessWidget {
  InfoCard({
    @required this.title,
    @required this.data,
    @required this.dialogueContent,
    this.unit = '',
    this.dialogueTitle = '',
  });

  final String title;
  final String data;
  final String unit;
  final String dialogueTitle;
  final Widget dialogueContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: subheadingStyle,
                  ),
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.info_outline,
                  color: Colors.black38,
                  size: 20.0,
                ),
                //padding: EdgeInsets.all(0.0),
                //visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                          dialogueTitle,
                          style: dialogueTitleStyle,
                        ),
                        content: dialogueContent,
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            style: textButtonStyle,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                      );
                    },
                  );
                },
              )
            ],
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
