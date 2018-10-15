import 'package:flutter/material.dart';
import 'api.dart';
import 'components/AsyncList.dart';
import 'pages/EndpointTabView.dart';
import 'types/Endpoint.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final api = Api();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EndpointSelectPage(title: 'Select an endpoint'),
    );
  }
}

class EndpointSelectPage extends StatefulWidget {

  final String title;

  EndpointSelectPage({Key key, this.title}) : super(key: key);

  @override
  _EndpointSelectPageState createState() => _EndpointSelectPageState();
}

class _EndpointSelectPageState extends State<EndpointSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              MyApp.api.endpoints = null;
              setState(() => _EndpointSelectPageState());
            },
          ),
        ],
      ),
      body: AsyncList(
        MyApp.api.getEndpoints(),
        builder: (BuildContext context, Endpoint endpoint) => ListTile(
          title: Text(endpoint.name, style: TextStyle(fontSize: 18.0)),
          trailing: Container(
            child: Text(endpoint.status.toString()),
            decoration: BoxDecoration(
              color: endpoint.status == "up" ? Colors.green[300] : Colors.red[300],
              borderRadius: BorderRadius.circular(5.0)
            ),
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EndpointTabView(endpoint))
          )
        )
      )
    );
  }
}
