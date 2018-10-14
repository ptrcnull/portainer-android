import 'package:flutter/material.dart';
import 'containers.dart';
import '../types/DContainer.dart';
import '../types/Endpoint.dart';

var colors = {
  'running': Colors.green[300],
  'exited': Colors.red[300],
  'stopped': Colors.red[300],
  'paused': Colors.lightBlue,
  'restarting': Colors.lightBlue
};

void refreshContainers (BuildContext context, Endpoint endpoint) {
  endpoint.containers = null;
  endpoint.getContainers();
  Navigator.of(context).pop();
  Navigator.of(context).pop();
  Navigator.of(context).push(getContainersForEndpoint(endpoint));
}

void startContainer (BuildContext context, DContainer container) async {
  await container.start();
  print('Started!');
  refreshContainers(context, container.endpoint);
}

void stopContainer (BuildContext context, DContainer container) async {
  await container.stop();
  print('Stopped!');
  refreshContainers(context, container.endpoint);
}

void pauseContainer (BuildContext context, DContainer container) async {
  await container.pause();
  print('Paused!');
  refreshContainers(context, container.endpoint);
}

void unpauseContainer (BuildContext context, DContainer container) async {
  await container.unpause();
  print('Unpaused!');
  refreshContainers(context, container.endpoint);
}

void restartContainer (BuildContext context, DContainer container) async {
  await container.restart();
  print('Restarted!');
  refreshContainers(context, container.endpoint);
}

MaterialPageRoute getContainerPage(DContainer container) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text(container.name),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.refresh, color: Colors.white),
          //     onPressed: () {
          //       endpoint.containers = null;
          //       Navigator.of(context).pop();
          //       Navigator.of(context).push(getContainersForEndpoint(endpoint));
          //     },
          //   ),
          // ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            new ListTile(
              title: Row(
                children: <Widget>[
                  getButton(
                    Icons.play_arrow,
                    colors['running'],
                    onPressed: container.state != 'running' ? () => startContainer(context, container) : null
                  ),
                  getButton(
                    Icons.stop,
                    colors['exited'],
                    onPressed: container.state == 'running' ? () => stopContainer(context, container) : null
                  ),
                  getButton(
                    Icons.pause,
                    colors['paused'],
                    onPressed: container.state == 'running' ? () => pauseContainer(context, container) : null
                  ),
                  getButton(
                    Icons.play_arrow,
                    colors['paused'],
                    onPressed: container.state == 'paused' ? () => unpauseContainer(context, container) : null
                  ),
                  getButton(
                    Icons.refresh,
                    colors['restarting'],
                    onPressed: container.state == 'running' ? () => restartContainer(context, container) : null
                  ),
                ],
                
              ),
            ),
            new ListTile(
              title: Text('State', style: TextStyle(fontSize: 18.0)),
              trailing: Container(
                child: Text(container.status.toLowerCase()),
                decoration: BoxDecoration(
                  color: colors[container.state],
                  borderRadius: BorderRadius.circular(5.0)
                ),
                padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              ),
            ),
            new ListTile(
              title: Text('Image', style: TextStyle(fontSize: 18.0)),
              trailing: Text(container.image),
            ),
          ],
        ),
      );
    },
  );
}

ButtonTheme getButton (IconData icon, Color color, { Function onPressed }) {
  return ButtonTheme(
    minWidth: 0.0,
    height: 36.0,
    child: RaisedButton(
      child: Icon(icon),
      color: color,
      onPressed: onPressed,
    ),
    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0)
  );
}
