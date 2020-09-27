
import 'package:flutter/material.dart';

class SystemPadding extends StatelessWidget {
  final Widget child;

  const SystemPadding({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      padding: mediaQuery.viewPadding,
      duration: Duration(milliseconds: 1500),
      child: child,
    );
  }
}
