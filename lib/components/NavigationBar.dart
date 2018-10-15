import 'package:flutter/material.dart';
import '../types/Endpoint.dart';

class NavigationBar extends StatefulWidget {
  final TabController controller;
  final Endpoint endpoint;
  NavigationBar(this.controller, this.endpoint);

  @override
  State<StatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int currentIndex;

  void setIndex (int index) {
    widget.controller.animateTo(index);
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        currentIndex = widget.controller.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          createItem('Containers', Icons.dns, 0),
          createItem('Images', Icons.image, 1),
          Expanded(child: SizedBox(height: 48.0)),
          createItem('Volumes', Icons.disc_full, 2),
          createItem('Networks', Icons.network_wifi, 3),
        ],
      ),
      shape: CircularNotchedRectangle(),
    );
  }

  Expanded createItem (String name, IconData icon, int index) {
    final color = widget.controller.index == index ? Colors.blue : Colors.grey;
    return Expanded(
      child: SizedBox(
        height: 48.0,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => setIndex(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: color),
                Text(name, style: TextStyle(color: color, fontSize: 12.0))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

