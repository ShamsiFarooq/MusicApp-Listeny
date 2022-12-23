import 'package:flutter/material.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/screens/screen_main/bottom_navbar.dart';
import 'package:listeny/style/constant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    addCheck();
    goToBOttomNav();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: Center(
        child: Image.asset(
          'assets/img/ListenyLogo1.png',
          height: 200,
          width: 200,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> goToBOttomNav() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx1) => const BottomNavBar(),
    ));
  }

  addCheck() async {

    List<SongModel> songs = [];
    final musicDB = await Hive.openBox<MusicModel>('musics');
    final audioQuery = OnAudioQuery();
    songs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    songs = songs;
    if (musicDB.values.length < songs.length) {
      musicDB.deleteAll(musicDB.keys);
      for (int i = 0; i < songs.length; i++) {
        final value = MusicModel(
          id: songs[i].id,
          uri: songs[i].uri,
          artist: songs[i].artist,
          name: songs[i].displayNameWOExt,
          title: songs[i].title,
          album: songs[i].album,
          artistID: songs[i].artistId,
          isFav: false,
        );
        musicDB.add(value);
      }
    }

    setState(() {});
  }
}
