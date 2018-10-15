import 'dart:async';
import 'package:flutter/material.dart';

Future showLoader (BuildContext context, Future future) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Loader(future: future, close: (value) => Navigator.of(context).pop(value));
    }
  );
}

class Loader extends StatefulWidget {

  final Future future;
  final Function close;

  Loader({Key key, this.future, this.close}): super(key: key);

  @override
  _LoaderState createState() => _LoaderState();

}

class _LoaderState extends State<Loader> {
  String loaderText = 'Loading...';
  bool get isLoading => loaderText == 'Loading...';

  void setText (String text) {
    setState(() {
      loaderText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.future.then((value) => widget.close(value)).catchError((error) => setText(error.toString()));
    return Dialog(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        children: [
          ListTile(title: Text("$loaderText")),
          ListTile(title: isLoading ?
            Center(child: CircularProgressIndicator())
            :
            RaisedButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              color: Colors.blue,
              onPressed: () async {
                widget.close(null);
              },
            )
          ),
        ],
      ),
    );
  }
}
