import 'package:flutter/material.dart';
import '../types/DContainer.dart';
import '../components/loader.dart';
import '../components/LogsWidget.dart';
import '../components/ControlButton.dart';
import 'LogsPage.dart';

var colors = {
  'running': Colors.green[300],
  'exited': Colors.red[300],
  'stopped': Colors.red[300],
  'paused': Colors.lightBlue,
  'restarting': Colors.lightBlue
};

class ContainerPage extends StatefulWidget {
  final DContainer container;
  ContainerPage(this.container);

  @override
  State<StatefulWidget> createState() => _ContainerPageState(container);
}

class _ContainerPageState extends State<ContainerPage> {
  DContainer container;
  _ContainerPageState(this.container);

  void refresh() async {
    final endpoint = container.endpoint;
    endpoint.containers = null;
    await showLoader(context, endpoint.getContainers());
    if (endpoint.containers.any((_container) => _container.id == container.id)) {
      setState(() {
        container = endpoint.containers.firstWhere((_container) => _container.id == container.id);
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void start() async {
    await showLoader(context, container.start());
    refresh();
  }

  void stop() async {
    await showLoader(context, container.stop());
    refresh();
  }

  void pause() async {
    await showLoader(context, container.pause());
    refresh();
  }

  void unpause() async {
    await showLoader(context, container.unpause());
    refresh();
  }

  void restart() async {
    await showLoader(context, container.restart());
    refresh();
  }

  void delete() async {
    final delete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${container.name}?'),
          content: Text('This action will irreversibly delete this container.'),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text("CONFIRM", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      }
    );
    if (!delete) return;
    await showLoader(context, container.delete());
    refresh();
  }

  ListTile getControls() {
    return ListTile(
      title: Row(
        children: <Widget>[
          ControlButton(
            Icons.play_arrow, colors['running'],
            onPressed: container.isStopped ? () => start() : null
          ),
          ControlButton(
            Icons.stop, colors['exited'],
            onPressed: container.isRunning ? () => stop() : null
          ),
          ControlButton(
            Icons.pause, colors['paused'],
            onPressed: container.isRunning ? () => pause() : null
          ),
          ControlButton(
            Icons.play_arrow, colors['paused'],
            onPressed: container.isPaused ? () => unpause() : null
          ),
          ControlButton(
            Icons.refresh, colors['restarting'],
            onPressed: container.isRunning ? () => restart() : null
          ),
          ControlButton(
            Icons.delete, colors['exited'],
            onPressed: container.isStopped ? () => delete() : null
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(container.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => refresh(),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          getControls(),
          ListTile(
            title: Text('State', style: TextStyle(fontSize: 18.0)),
            trailing: Container(
              child: Text(container.status.toLowerCase()),
              decoration: BoxDecoration(
                color: colors[container.state],
                borderRadius: BorderRadius.circular(5.0)
              ),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            ),
          ),
          ListTile(
            title: Text('Image', style: TextStyle(fontSize: 18.0)),
            trailing: Text(container.image),
          ),
          ListTile(
            title: Text('Logs', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LogsPage(container)
                )
              );
            }
          ),
          ListTile(
            title: LogsWidget(container, count: 20)
          )
        ],
      ),
    );
  }
}
