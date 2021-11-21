import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String message;
  EmptyData(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info, size: 30,),
          Text(message),
        ],
      ),
    );
  }
}
