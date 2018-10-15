import 'package:flutter/material.dart';
import '../types/DContainer.dart';
import '../components/LogsWidget.dart';

class LogsPage extends StatelessWidget {
  final DContainer container;
  LogsPage(this.container);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(container.name + ' > Logs'),
      ),
      body: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          ListTile(
            title: LogsWidget(container, count: 1000),
          )
        ]
      ),
    );
  }
}
