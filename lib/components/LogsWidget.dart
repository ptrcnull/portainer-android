import 'package:flutter/material.dart';
import '../types/DContainer.dart';

class LogsWidget extends StatefulWidget {

  final DContainer container;
  final int count;

  LogsWidget(this.container, {this.count, Key key}): super(key: key);

  @override
  _LogsWidgetState createState() => _LogsWidgetState();

}


class _LogsWidgetState extends State<LogsWidget> {
  String content = 'Loading...';
  bool loaded = false;

  void setText (String text) {
    setState(() {
      var lines = text.split("\n");
      var linesSubstringed = lines.map((value) {
        if (value.length == 0) return value;
        return value.substring(8);
      }).toList();
      content = linesSubstringed.join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      widget.container.getLogs(widget.count).then((value) {
        setText(value);
        loaded = true;
      }).catchError((error) {
        setText(error.toString());
        loaded = true;
      });
    }
    return Container(
      child: Text(
        '$content',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 8.0,
        )
      ),
      decoration: BoxDecoration(color: Colors.grey[200])
    );
  }
}
