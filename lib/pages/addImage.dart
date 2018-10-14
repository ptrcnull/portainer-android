import 'package:flutter/material.dart';
import '../types/Endpoint.dart';

MaterialPageRoute getAddImagePage(Endpoint endpoint) {
  final pullController = TextEditingController();
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text(endpoint.name + ' > New image'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            new ListTile(
              title: Text('Pull an image', style: TextStyle(fontSize: 18.0)),
            ),
            new ListTile(
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'eg. myImage:myTag'
                ),
                controller: pullController,
              ),
              trailing: RaisedButton(
                child: Text('PULL', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
                onPressed: () async {
                  final text = pullController.text.split(':');
                  await endpoint.pullImage(text[0], text.length > 1 ? text[1] : 'latest');
                },
              ),
            ),
            new Divider(),
            new ListTile(
              title: Text('Build an image', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        ),
      );
    },
  );
}