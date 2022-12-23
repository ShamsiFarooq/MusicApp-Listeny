import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/screens/playing_screen/playing_screen.dart';
import 'package:listeny/screens/playlist/playlist_all/playlist_screen.dart';
import 'package:listeny/screens/playlist/playlist_all/screen_list_song.dart';
import 'package:listeny/screens/search.dart/screen_search.dart';
import 'package:listeny/screens/widgets/logo_section.dart';
import 'package:listeny/style/constant.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const HomeScreen({super.key, required this.audioPlayer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    permissionHandle();
    musics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: logoBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headText(text: 'Songs'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ValueListenableBuilder(
                  valueListenable: musicNotifier,
                  builder: (BuildContext context, List<MusicModel> value,
                      Widget? child) {
                    if (value.isEmpty) {
                      return noSongWidget();
                    }
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => ScreenPlay(index: index),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(
                              top: 15,
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
                                  musicImg(),
                                  width15,
                                  Expanded(child: musicDetails(value, index)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      favButton(index, value),
                                      playlistButton(value[index].id),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            height15,
            //miniPlayer(),
          ],
        ),
      ),
    );
  }

  Text headText({required String text}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 35,
        color: color4,
      ),
    );
  }

  AppBar logoBar() {
    return AppBar(
      backgroundColor: color2,
      flexibleSpace: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //height50,
          const SizedBox(
            height: 25,
          ),
          Row(
            children: const [
              width15,
              LogoListeny(),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) => ScreenSearch(
                      audioPlayer: audioPlayer,
                    )));
          },
        ),
        width30,
      ],
      elevation: 10,
    );
  }

  permissionHandle() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
      setState(() {
        musics();
      });
    }
  }

  musics() async {
    getAllMusic();
  }

  Center noSongWidget() {
    return Center(
        child: Text(
      'No Songs found',
      style: TextStyle(color: color4, fontSize: 2),
    ));
  }

  musicImg() {
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/img/ListenyLogo1.png'),
    );
  }

  audioName(name) {
    try {
      return '${name.substring(0, 15)}...';
    } catch (e) {
      int length = name.length;
      return name.substring(0, length);
    }
  }

  artistName(name) {
    try {
      return '${name.substring(0, 12)}...';
    } catch (e) {
      int length = name.length;
      return name.substring(0, length);
    }
  }

  //

  Container miniPlayer() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_previous),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_circle),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_next),
          ),
        ],
      ),
    );
  }

  Column musicDetails(List<MusicModel> value, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6.5),
        Text(
          audioName(value[index].title),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, color: color4),
        ),
        Text(
          artistName(value[index].album!),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10, color: color3),
        )
      ],
    );
  }

  IconButton favButton(int index, List<MusicModel> value) {
    return IconButton(
      onPressed: () => setState(() {
        favOption(value[index].id, context);
      }),
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: color4,
      ),
    );
  }

  IconButton playlistButton(int songID) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => AddToPlaylist(id: songID)));
      },
      icon: const Icon(
        Icons.playlist_add,
        size: 30,
      ),
      color: color4,
    );
  }
}
