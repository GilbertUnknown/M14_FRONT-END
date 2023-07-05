import 'package:flutter/material.dart';

import 'mainpage.dart';

class profile extends StatefulWidget {
  final List data;
  const profile({super.key, required this.data});
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.account_circle,
              size: 30,
            ),
            title: Text('Gilbert'),
            subtitle: Text(
                'Task Finished: ${widget.data.where((val) => val.isChecked).length}'),
          ),
        ])),
        Row(
          children: [
            Container(
              width: 200,
              height: 200,
              child: Card(
                child: Column(
                  children: [
                    Text('Routine'),
                    Text(
                      ' ${widget.data.where((val) => val.isChecked && val.category == 'Routine').length}',
                      style: TextStyle(fontSize: 30, color: Colors.yellow),
                    ),
                    Text('Finished')
                  ],
                ),
              ),
            ),
            Container(
              width: 200,
              height: 200,
              child: Card(
                child: Column(
                  children: [
                    Text('Work'),
                    Text(
                        '${widget.data.where((val) => val.isChecked && val.category == 'Work').length}',
                        style: TextStyle(fontSize: 30, color: Colors.red)),
                    Text('Finished')
                  ],
                ),
              ),
            ),
            Container(
              width: 200,
              height: 200,
              child: Card(
                child: Column(
                  children: [
                    Text('Others'),
                    Text(
                        '${widget.data.where((val) => val.isChecked && val.category == 'Others').length}',
                        style: TextStyle(fontSize: 30, color: Colors.green)),
                    Text('Finished')
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height:20),
        Card(
          child: Column(
            children: [SliderTheme(
              data: SliderThemeData(
                thumbShape: RoundSliderThumbShape(disabledThumbRadius: 0),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                disabledActiveTrackColor: Colors.red,
                disabledInactiveTrackColor: Colors.grey,
              ),
              child: Slider(
                min: 0,
                max: widget.data.length.toDouble(),
                value: widget.data.where((val) => val.isChecked).length.toDouble(), 
                onChanged: null
                ),
            ),
            Text(widget.data.length-widget.data.where((val) => val.isChecked).length != 0?'you still have ${widget.data.length-widget.data.where((val) => val.isChecked).length} task to do':'All Task Done')],
          ),
        )
      ],
    );
  }
}