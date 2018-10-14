import 'package:flutter/material.dart';
import '../components/asyncList.dart';
import './container.dart';
import '../types/Endpoint.dart';
import '../types/DContainer.dart';

var colors = {
  'running': Colors.green[300],
  'exited': Colors.red[300],
  'stopped': Colors.red,
  'paused': Colors.lightBlue,
  'restarting': Colors.lightBlue
};

MaterialPageRoute getContainersForEndpoint(Endpoint endpoint) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text('${endpoint.name}: Containers'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                endpoint.containers = null;
                Navigator.of(context).pop();
                Navigator.of(context).push(getContainersForEndpoint(endpoint));
              },
            ),
          ],
        ),
        body: createAsyncList(
          endpoint.getContainers(),
          handler: (context, DContainer container) => ListTile(
            title: Text(container.name, style: TextStyle(fontSize: 18.0)),
            trailing: Container(
              child: Text(container.status.toLowerCase()),
              decoration: BoxDecoration(
                color: colors[container.state],
                borderRadius: BorderRadius.circular(5.0)
              ),
              padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            ),
            onTap: () {
              Navigator.of(context).push(getContainerPage(container));
            },
          )
        )
      );
    },
  );
}