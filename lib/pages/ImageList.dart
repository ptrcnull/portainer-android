import 'package:flutter/material.dart';
import '../components/AsyncList.dart';
import 'ImagePage.dart';
import '../types/Endpoint.dart';
import '../types/DImage.dart';

class ImageList extends StatelessWidget {
  final Endpoint endpoint;
  ImageList(this.endpoint);

  @override
  Widget build(BuildContext context) {
    return AsyncList(
      endpoint.getImages(),
      builder: (BuildContext context, DImage image) => ListTile(
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
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          ) : null,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ImagePage(image))
          );
        },
      ),
    );
  }
}
