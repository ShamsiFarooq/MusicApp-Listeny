import 'package:flutter/material.dart';
import 'package:listeny/style/constant.dart';

import 'package:on_audio_query/on_audio_query.dart';

SizedBox imageWidget(index) {
  return SizedBox(
    height: 50,
    width: 50,
    child: QueryArtworkWidget(
      id: audio[index].id,
      type: ArtworkType.AUDIO,
      artworkBorder: BorderRadius.zero,
      nullArtworkWidget: Image.asset('assets/img/ListenyLogo1.png'),
    ),
  );
}
