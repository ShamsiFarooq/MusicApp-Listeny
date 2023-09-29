import 'package:flutter/material.dart';
import 'package:listeny/View/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:listeny/constants/constants.dart';

IconButton playlistButton(BuildContext context, music) {
  return IconButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AddToPlaylist(
            id: music.id,
          ),
        ),
      );
    },
    icon: const Icon(Icons.playlist_add),
    iconSize: 30,
    color: textColor,
  );
}
