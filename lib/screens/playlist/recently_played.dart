// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/screens/playlist/playlist_all/screen_list_song.dart';
import 'package:listeny/style/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenRecentPlayed extends StatefulWidget {
  const ScreenRecentPlayed({super.key});

  @override
  State<ScreenRecentPlayed> createState() => _ScreenRecentPlayedState();
}

class _ScreenRecentPlayedState extends State<ScreenRecentPlayed> {
  ValueNotifier<List<MusicModel>> recent = ValueNotifier([]);

  adding() async {
    await addAllRecent();
    getAllRecentList();
  }

  @override
  void initState() {
    adding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: ValueListenableBuilder(
        valueListenable: recent,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return noSongsWidget();
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20),
                  child: Row(
                    children: [
                      musicImage(audio.indexOf(value[index])),
                      width15,
                      songDetails(value, index),
                      favButton(value, index, context),
                      height15,
                   
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => separatorWidget(),
            itemCount: value.length,
          );
        },
      ),
    );
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon:  Icon(
            Icons.arrow_back,
            color: color4,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title:  Text(
        'Recently Played',
        style: TextStyle(
          color: color4,
          fontSize: 25,
          fontFamily: 'Caveat'
        ),
      ),
      backgroundColor: color2,
    );
  }

  Center noSongsWidget() {
    return  Center(
      child: Text(
        "No Songs Played recently",
        style: TextStyle(
          fontSize: 20,
          color: color4,
        ),
      ),
    );
  }

  SizedBox musicImage(index) {
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

  Expanded songDetails(List<MusicModel> value, int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value[index].title!,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(fontSize: 15, color: color4),
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            value[index].artist!,
            style:  TextStyle(fontSize: 11, color: color3),
          )
        ],
      ),
    );
  }

  IconButton favButton(
      List<MusicModel> value, int index, BuildContext context) {
    return IconButton(
      onPressed: () => setState(() {
        favOption(value[index].id, context);
      }),
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: color4,
        size: 30,
      ),
    );
  }


  Padding separatorWidget() {
    return  Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Divider(
        color: color1,
      ),
    );
  }

  getAllRecentList() {
   recent.value.clear();
    for (int i = recentNotifier.value.length - 1; i >= 0; i--) {
      for (int j = 0; j < musicNotifier.value.length; j++) {
        if (recentNotifier.value[i].songIds == musicNotifier.value[j].id) {
          recent.value.add(musicNotifier.value[j]);
        }
      }
    }
    recent.notifyListeners();
  }
}
