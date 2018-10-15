import 'package:flutter/material.dart';
import '../types/Endpoint.dart';
import '../components/Loader.dart';

class NewImagePage extends StatelessWidget {
  final Endpoint endpoint;
  final pullController = TextEditingController();
  final buildUrlController = TextEditingController();
  final buildTagController = TextEditingController();
  NewImagePage(this.endpoint);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(endpoint.name + ' > New image'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Pull an image', style: TextStyle(fontSize: 18.0)),
          ),
          ListTile(
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
                await showLoader(context, endpoint.pullImage(text[0], text.length > 1 ? text[1] : 'latest'));
                endpoint.images = null;
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Build an image', style: TextStyle(fontSize: 18.0)),
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Dockerfile URL'
              ),
              controller: buildUrlController,
            )
          ),
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Image tag'
              ),
              controller: buildTagController,
            ),
            trailing: RaisedButton(
              child: Text('BUILD', style: TextStyle(color: Colors.white)),
              color: Colors.blue,
              onPressed: () async {
                final url = buildUrlController.text;
                final tag = buildTagController.text;
                await showLoader(context, endpoint.buildImage(tag, url));
                endpoint.images = null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
