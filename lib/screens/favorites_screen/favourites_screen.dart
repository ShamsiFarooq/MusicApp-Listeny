import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/screens/playing_screen/playing_screen.dart';
import 'package:listeny/screens/playlist/playlist_all/screen_list_song.dart';
import 'package:listeny/screens/widgets/list_view_divider.dart';
import 'package:listeny/style/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<MusicModel> allMusics = [];
ValueNotifier<List<MusicModel>> favMusic = ValueNotifier([]);

class ScreenFavorite extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const ScreenFavorite({super.key, required this.audioPlayer});

  @override
  State<ScreenFavorite> createState() => _ScreenFavoriteState();
}

class _ScreenFavoriteState extends State<ScreenFavorite> {
  @override
  void initState() {
    getFavMusics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getFavMusics();
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headText(text: 'Favourite'),
          height15,
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: favMusic,
            builder: (context, value, child) {
              if (value.isEmpty) {
                return noFavWidget();
              }
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ScreenPlay(
                                  index: indexFinder(favMusic.value[index])))),
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              width15,
                              musicImgae(audio.indexOf(value[index])),
                              width15,
                              musicDetails(value, index),
                              favButton(value, index, context),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => listViewDivider(),
                  itemCount: value.length);
            },
          ))
        ],
      )),
    );
  }

  Text headText({required String text}) {
    return Text(
      text,
      style: TextStyle(fontSize: 35, color: color4, fontFamily: 'Caveat'),
    );
  }

  IconButton addPlaylistButton(
      BuildContext context, List<MusicModel> value, int index) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AddToPlaylist(
              id: value[index].id,
            ),
          ),
        );
      },
      icon: const Icon(Icons.playlist_add),
      iconSize: 30,
      color: color4,
    );
  }

  IconButton favButton(
      List<MusicModel> value, int index, BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          favOption(value[index].id, context);
        });
      },
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: color4,
        size: 30,
      ),
    );
  }

  Center noFavWidget() {
    return Center(
        child: Text(
      'No Favourites yet',
      style: TextStyle(color: color4, fontSize: 20),
    ));
  }

  SizedBox musicImgae(index) {
    return SizedBox(
      height: 40,
      width: 40,
      child: QueryArtworkWidget(
        id: audio[index].id,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.zero,
        nullArtworkWidget: Image.asset('assets/img/ListenyLogo1.png'),
      ),
    );
  }

  Expanded musicDetails(List<MusicModel> value, int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value[index].title!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(fontSize: 15, color: color4),
          ),
          Text(
            value[index].artist!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: color3),
          )
        ],
      ),
    );
  }

  getFavMusics() {
    favMusic.value = [];
    allMusics = [];
    allMusics.addAll(musicNotifier.value);
    favMusic.value =
        allMusics.where((element) => element.isFav == true).toList();
    favMusic.notifyListeners();
    setState(() {});
  }

  indexFinder(data) {
    List<MusicModel> list = musicNotifier.value;
    return list.indexOf(data);
  }
}


//  SizedBox musicImgae(index) {
//     return SizedBox(
//       height: 50,
//       width: 50,
//       child: QueryArtworkWidget(
//         id: audio[index].id,
//         type: ArtworkType.AUDIO,
//         artworkBorder: BorderRadius.zero,
//         nullArtworkWidget: Image.asset('assets/img/ListenyLogo1.png'),
//       ),
//     );
//   }