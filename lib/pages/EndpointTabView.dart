import 'package:flutter/material.dart';
import 'ContainerList.dart';
import 'ImageList.dart';
import '../types/Endpoint.dart';
import '../components/NavigationBar.dart';
import 'NewImagePage.dart';

var listItems = [
  'Dashboard',
  'Containers',
  'Images',
  'Volumes'
];

class EndpointTabView extends StatefulWidget {
  final Endpoint endpoint;
  EndpointTabView(this.endpoint, { Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EndpointTabViewState();
}

class _EndpointTabViewState extends State<EndpointTabView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }
 
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.endpoint.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              if (_tabController.index == 0) widget.endpoint.containers = null;
              if (_tabController.index == 1) widget.endpoint.images = null;
              if (_tabController.index == 2) widget.endpoint.volumes = null;
              if (_tabController.index == 3) widget.endpoint.volumes = null;
              refresh();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ContainerList(widget.endpoint),
          ImageList(widget.endpoint),
          Center(child: Text('Volumes')),
          Center(child: Text('Networks')),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (_tabController.index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NewImagePage(widget.endpoint))
            );
          }
        },
      ),
      bottomNavigationBar: NavigationBar(_tabController, widget.endpoint),
    );
  }
}