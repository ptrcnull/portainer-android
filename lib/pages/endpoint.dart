import 'package:flutter/material.dart';
import 'containers.dart';
import '../types/Endpoint.dart';

var listItems = [
  'Dashboard',
  'Containers',
  'Images',
  'Volumes'
];

MaterialPageRoute getMainEndpointPage(Endpoint endpoint) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text(endpoint.name),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: <ListTile>[
            new ListTile(
              title: Text('Containers', style: TextStyle(fontSize: 18.0)),
              trailing: Text(
                endpoint.runningContainers.toString() + '/' +
                endpoint.containerCount.toString() + ' running'
              ),
              onTap: () => Navigator.of(context).push(getContainersForEndpoint(endpoint))
            ),
            new ListTile(
              title: Text('Images', style: TextStyle(fontSize: 18.0)),
              trailing: Text(endpoint.imageCount.toString()),
            ),
            new ListTile(
              title: Text('Volumes', style: TextStyle(fontSize: 18.0)),
              trailing: Text(endpoint.volumeCount.toString()),
            ),
          ],
        ),
      );
    },
  );
}