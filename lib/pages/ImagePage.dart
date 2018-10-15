import 'package:flutter/material.dart';
import '../types/DImage.dart';
import '../components/loader.dart';

class ImagePage extends StatefulWidget {
  final DImage image;

  ImagePage(this.image);

  @override
  State<StatefulWidget> createState() => _ImagePageState(image);
}

class _ImagePageState extends State<ImagePage> {
  DImage image;
  _ImagePageState(this.image);

  void refresh() async {
    print('Refreshing!');
    final endpoint = image.endpoint;
    endpoint.images = null;
    await showLoader(context, endpoint.getImages());
    if (endpoint.images.any((_image) => _image.id == image.id)) {
      setState(() {
        image = endpoint.images.firstWhere((_image) => _image.id == image.id);
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void delete() async {
    final delete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${image.id}?'),
          content: Text('This action will irreversibly delete this image.'),
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
    await showLoader(context, image.delete());
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image.id),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: refresh,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('ID', style: TextStyle(fontSize: 18.0)),
            trailing: Text(image.id),
          ),
          ListTile(
            title: Text('Tags', style: TextStyle(fontSize: 18.0)),
            trailing: Text(image.tags != null ? image.tags.toString() : '(none)'),
          ),
          ListTile(
            title: Text('Size', style: TextStyle(fontSize: 18.0)),
            trailing: Text((image.size / 1024 / 1024).toStringAsFixed(2) + 'MiB'),
          ),
          ListTile(
            title: Center(
              child: RaisedButton(
                child: Text('DELETE'),
                onPressed: delete,
              )
            )
          )
        ],
      ),
    );
  }
}
