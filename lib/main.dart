import 'package:flutter/material.dart';
import 'api.dart';
import 'components/asyncList.dart';
import 'pages/endpoint.dart';
import 'types/Endpoint.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static final api = new Api();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Portainer',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new EndpointSelectPage(title: 'Select an endpoint'),
    );
  }
}

class EndpointSelectPage extends StatefulWidget {

  final String title;

  EndpointSelectPage({Key key, this.title}) : super(key: key);

  @override
  _EndpointSelectPageState createState() => new _EndpointSelectPageState();
}

class _EndpointSelectPageState extends State<EndpointSelectPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              MyApp.api.endpoints = null;
              this.setState(() => new _EndpointSelectPageState());
            },
          ),
        ],
      ),
      body: createAsyncList(
        MyApp.api.getEndpoints(),
        handler: (context, Endpoint endpoint) => ListTile(
          title: Text(endpoint.name, style: TextStyle(fontSize: 18.0)),
          trailing: Container(
            child: Text(endpoint.status.toString()),
            decoration: BoxDecoration(
              color: endpoint.status == "up" ? Colors.green[300] : Colors.red[300],
              borderRadius: BorderRadius.circular(5.0)
            ),
            padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          ),
          onTap: () => Navigator.of(context).push(getMainEndpointPage(endpoint))
        )
      )
    );
  }
}
