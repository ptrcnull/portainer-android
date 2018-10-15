import 'package:flutter/material.dart';
import '../components/AsyncList.dart';
import './ContainerPage.dart';
import '../types/Endpoint.dart';
import '../types/DContainer.dart';

var colors = {
  'running': Colors.green[300],
  'exited': Colors.red[300],
  'stopped': Colors.red,
  'paused': Colors.lightBlue,
  'restarting': Colors.lightBlue
};

class ContainerList extends StatelessWidget {
  final Endpoint endpoint;
  ContainerList(this.endpoint);

  @override
  Widget build(BuildContext context) {
    return AsyncList(
      endpoint.getContainers(),
      builder: (BuildContext context, DContainer container) => ListTile(
        title: Text(container.name, style: TextStyle(fontSize: 18.0)),
        trailing: Container(
          child: Text(container.status.toLowerCase()),
          decoration: BoxDecoration(
            color: colors[container.state],
            borderRadius: BorderRadius.circular(5.0)
          ),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContainerPage(container)));
        },
      )
    );
  }
}
