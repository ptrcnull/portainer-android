import 'package:flutter/material.dart';
import 'images.dart';
import '../types/Image.dart';

void refreshImage(BuildContext context, DImage image) async {
  final endpoint = image.endpoint;
  endpoint.images = null;
  await endpoint.getImages();
  if (endpoint.containers.any((_image) => _image.id == image.id)) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      getImagePage(
        endpoint.images.firstWhere((_image) => _image.id == image.id)
      )
    );
  } else {
    Navigator.of(context).pop();
    Navigator.of(context).push(getImagesPage(endpoint));
  }
}

MaterialPageRoute getImagePage(DImage image) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text(image.id),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () => refreshImage(context, image),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            new ListTile(
              title: Text('ID', style: TextStyle(fontSize: 18.0)),
              trailing: Text(image.id),
            ),
            new ListTile(
              title: Text('Tags', style: TextStyle(fontSize: 18.0)),
              trailing: Text(image.tags != null ? image.tags.toString() : '(none)'),
            ),
            new ListTile(
              title: Text('Size', style: TextStyle(fontSize: 18.0)),
              trailing: Text((image.size / 1024 / 1024).toStringAsFixed(2) + 'MiB'),
            ),
          ],
        ),
      );
    },
  );
}