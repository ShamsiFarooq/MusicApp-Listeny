import 'package:flutter/material.dart';
import 'package:listeny/style/constant.dart';

Center noSongsWidget() {
  return  Center(
    child: Text(
      'No Songs Found',
      style: TextStyle(color: color4, fontSize: 20),
    ),
  );
}
