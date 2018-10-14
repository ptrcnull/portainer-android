import 'package:flutter/material.dart';
import 'containers.dart';
import '../types/DContainer.dart';

var colors = {
  'running': Colors.green[300],
  'exited': Colors.red[300],
  'stopped': Colors.red[300],
  'paused': Colors.lightBlue,
  'restarting': Colors.lightBlue
};

void refreshContainer(BuildContext context, DContainer container) async {
  final endpoint = container.endpoint;
  endpoint.containers = null;
  await endpoint.getContainers();
  if (endpoint.containers.any((_container) => _container.id == container.id)) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      getContainerPage(
        endpoint.containers.firstWhere((_container) => _container.id == container.id)
      )
    );
  } else {
    Navigator.of(context).pop();
    Navigator.of(context).push(getContainersForEndpoint(endpoint));
  }
}

void startContainer (BuildContext context, DContainer container) async {
  await container.start();
  print('Started!');
  refreshContainer(context, container);
}

void stopContainer (BuildContext context, DContainer container) async {
  await container.stop();
  print('Stopped!');
  refreshContainer(context, container);
}

void pauseContainer (BuildContext context, DContainer container) async {
  await container.pause();
  print('Paused!');
  refreshContainer(context, container);
}

void unpauseContainer (BuildContext context, DContainer container) async {
  await container.unpause();
  print('Unpaused!');
  refreshContainer(context, container);
}

void restartContainer (BuildContext context, DContainer container) async {
  await container.restart();
  print('Restarted!');
  refreshContainer(context, container);
}

void deleteContainer (BuildContext context, DContainer container) async {
  final delete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete ${container.name}?'),
        content: Text('This action will irreversibly delete this container.'),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          new FlatButton(
            child: new Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    }
  );
  if (!delete) return;
  await container.delete();
  print('Restarted!');
  refreshContainer(context, container);
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
            getControls(context, container),
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

ListTile getControls(BuildContext context, DContainer container) {
  return new ListTile(
    title: Row(
      children: <Widget>[
        getButton(
          Icons.play_arrow,
          colors['running'],
          onPressed: container.isStopped ? () => startContainer(context, container) : null
        ),
        getButton(
          Icons.stop,
          colors['exited'],
          onPressed: container.isRunning ? () => stopContainer(context, container) : null
        ),
        getButton(
          Icons.pause,
          colors['paused'],
          onPressed: container.isRunning ? () => pauseContainer(context, container) : null
        ),
        getButton(
          Icons.play_arrow,
          colors['paused'],
          onPressed: container.isPaused ? () => unpauseContainer(context, container) : null
        ),
        getButton(
          Icons.refresh,
          colors['restarting'],
          onPressed: container.isRunning ? () => restartContainer(context, container) : null
        ),
        getButton(
          Icons.delete,
          colors['exited'],
          onPressed: container.isStopped ? () => deleteContainer(context, container) : null
        ),
      ],
    ),
  );
}
