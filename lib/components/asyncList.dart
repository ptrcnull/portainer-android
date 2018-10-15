import 'dart:async';
import 'package:flutter/material.dart';

class AsyncList extends StatelessWidget {
  final Future future;
  final Function builder;

  AsyncList(this.future, { this.builder = createListTile });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none: return Center(child: Text('Waiting to start'));
          case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();
                final index = i ~/ 2;
                return builder(context, snapshot.data[index]);
              },
              itemCount: snapshot.data.length * 2
            );
        }
      }
    );
  }
}

ListTile createListTile(context, value) {
  return ListTile(
    title: Text(value.name, style: TextStyle(fontSize: 18.0)),
    onTap: () {}
  );
}
