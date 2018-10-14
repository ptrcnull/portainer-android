import 'package:flutter/material.dart';
import '../types/DContainer.dart';
import '../components/logs.dart';

MaterialPageRoute getContainerLogsPage(DContainer container) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
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
  );
}