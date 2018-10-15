import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onPressed;

  ControlButton(this.icon, this.color, { this.onPressed });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 0.0,
      height: 36.0,
      child: RaisedButton(
        child: Icon(icon),
        color: color,
        onPressed: onPressed,
      ),
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0)
    );
  }
}