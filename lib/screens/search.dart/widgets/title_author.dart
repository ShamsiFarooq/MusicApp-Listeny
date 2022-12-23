import 'package:flutter/material.dart';
import 'package:listeny/style/constant.dart';

Expanded titleAndAuthor(int index, foundList) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          foundList[index].title!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style:  TextStyle(fontSize: 15, color: color4),
        ),
        Text(
          foundList[index].artist!,
          overflow: TextOverflow.ellipsis,
          style:  TextStyle(fontSize: 11, color: color3),
        )
      ],
    ),
  );
}
