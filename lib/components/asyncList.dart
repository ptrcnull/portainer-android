import 'dart:async';
import 'package:flutter/material.dart';

void noop() {}

ListTile createListTile(context, value) {
  return new ListTile(
    title: Text(value.name, style: TextStyle(fontSize: 18.0)),
    onTap: noop
  );
}

Widget createAsyncList(Future future, { Function handler = createListTile }) {
  return new FutureBuilder<List>(
    future: future,
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none: return new Text('Waiting to start');
        case ConnectionState.waiting: return new Text('Loading...');
        default:
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          return new ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();
              final index = i ~/ 2;

              return handler(context, snapshot.data[index]);
            },
            itemCount: snapshot.data.length * 2
          );
      }
    }
  );
}
