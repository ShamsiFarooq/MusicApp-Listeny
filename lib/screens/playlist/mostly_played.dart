import 'package:flutter/material.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/db/db_model/recent_model/recent_model.dart';
import 'package:listeny/screens/playlist/playlist_all/screen_list_song.dart';
import 'package:listeny/style/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenMostPlayed extends StatefulWidget {
  const ScreenMostPlayed({super.key});

  @override
  State<ScreenMostPlayed> createState() => _ScreenMostPlayedState();
}

class _ScreenMostPlayedState extends State<ScreenMostPlayed> {
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
            return noDetailsWidget();
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                     left: 20, right: 20),
                  child: Row(
                    children: [
                      songImage(audio.indexOf(value[index])),
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
            itemCount: recent.value.length,
          );
        },
      ),
    );
  }

  Padding separatorWidget() {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: color1,
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
            value[index].artist!,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(fontSize: 11, color: color4),
          )
        ],
      ),
    );
  }

  SizedBox songImage(index) {
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

  Center noDetailsWidget() {
    return  Center(
      child: Text(
        "Not enought song details",
        style: TextStyle(
          fontSize: 20,
          color: color4,
        ),
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
        'Most Played',
        style: TextStyle(
          color: color4,
          fontSize: 25,
          fontFamily: 'Caveat'
        ),
      ),
      backgroundColor: color1,
    );
  }

  getAllRecentList() {
    recent.value.clear();
    final List<RecentModel> list =
        recentNotifier.value.where((element) => element.count > 5).toList();

    for (int i = list.length - 1; i >= 0; i--) {
      for (int j = 0; j < musicNotifier.value.length; j++) {
        if (list[i].songIds == musicNotifier.value[j].id) {
          recent.value.add(musicNotifier.value[j]);
        }
      }
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    recent.notifyListeners();
  }
}
