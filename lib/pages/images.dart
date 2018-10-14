import 'package:flutter/material.dart';
import '../components/asyncList.dart';
import 'image.dart';
import '../types/Endpoint.dart';
import '../types/DImage.dart';

MaterialPageRoute getImagesPage(Endpoint endpoint) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text('${endpoint.name} > Images'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                endpoint.images = null;
                Navigator.of(context).pop();
                Navigator.of(context).push(getImagesPage(endpoint));
              },
            ),
          ],
        ),
        body: createAsyncList(
          endpoint.getImages(),
          handler: (context, DImage image) => ListTile(
            title: Text(image.id, style: TextStyle(fontSize: 18.0)),
            trailing: image.tags != null && image.tags.length > 0 ?
              Container(
                child: Text(
                  image.tags[0].toLowerCase(),
                  style: TextStyle(fontSize: 10.0, color: Colors.white)
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5.0)
                ),
                padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              ) : null,
            onTap: () {
              Navigator.of(context).push(getImagePage(image));
            },
          )
        )
      );
    },
  );
}