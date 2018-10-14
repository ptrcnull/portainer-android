import 'dart:async';
import 'package:flutter/material.dart';

Future showLoader (BuildContext context, Future future) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return LoaderWidget(future: future, close: (value) => Navigator.of(context).pop(value));
    }
  );
}

class LoaderWidget extends StatefulWidget {

  final Future future;
  final Function close;

  LoaderWidget({Key key, this.future, this.close}): super(key: key);

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();

}

class _LoaderWidgetState extends State<LoaderWidget> {
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
    return new Dialog(
      child: new ListView(
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
