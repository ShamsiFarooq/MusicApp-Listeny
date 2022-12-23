import 'package:flutter/material.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/screens/favorites_screen/favourites_screen.dart';
import 'package:listeny/screens/home/home_screen.dart';
import 'package:listeny/screens/playing_screen/playing_screen.dart';
import 'package:listeny/screens/playlist/playlist_all/playlist_screen.dart';
import 'package:listeny/screens/settings/settings_screen.dart';
import 'package:listeny/style/constant.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndexNavBar = 0;
  final screens = [
    HomeScreen(audioPlayer: audioPlayer),
    ScreenFavorite(audioPlayer: audioPlayer),
    ScreenPlaylist(audioPlayer: audioPlayer),
    const SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screens[currentIndexNavBar],
          ValueListenableBuilder(
            valueListenable: isPlaying,
            builder: (context, value, child) {
              return value ? miniPlayer(context) : const Text('');
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndexNavBar,
        onTap: (value) => setState(() => currentIndexNavBar = value),
        iconSize: 40,
        selectedItemColor: color4,
        unselectedItemColor: color3,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            backgroundColor: color2,
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: color2,
            icon: const Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            backgroundColor: color2,
            icon: const Icon(Icons.library_music_outlined),
            label: 'Playlist',
          ),
          BottomNavigationBarItem(
            backgroundColor: color2,
            icon: const Icon(Icons.settings_applications),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Positioned miniPlayer(BuildContext context) {
    audioPlayer.playerStateStream.listen((event) {
      setState(() {});
    });
    int audioIndex = audioPlayer.currentIndex!;
    return Positioned(
      bottom: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ScreenPlay(index: audioPlayer.currentIndex!),
          ));
        },
        child: Container(
          color: color3,
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // kWidth30,
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                        image: AssetImage('assets/img/ListenyLogo1.png'))),
              ),
              // kWidth20,
              SizedBox(
                width: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      musicNotifier.value[audioIndex].title!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: color4, fontSize: 18),
                    ),
                    Text(
                      musicNotifier.value[audioIndex].artist!,
                      style: TextStyle(color: color3, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // kWidth20,
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (audioPlayer.hasPrevious) {
                        audioPlayer.pause();
                        audioPlayer.seekToPrevious();
                        audioPlayer.play();
                      }
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.skip_previous,
                      color: audioPlayer.hasPrevious
                          ? color4
                          : Colors.grey.withOpacity(0.5),
                      size: 25,
                    ),
                  ),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: color3,
                    child: IconButton(
                        onPressed: () {
                          if (audioPlayer.playing) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.play();
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                          color: color4,
                        )),
                  ),
                  IconButton(
                    onPressed: () {
                      if (audioPlayer.hasNext) {
                        audioPlayer.pause();
                        audioPlayer.seekToNext();
                        audioPlayer.play();
                      }
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.skip_next,
                      color: audioPlayer.hasNext
                          ? color4
                          : Colors.grey.withOpacity(0.5),
                      size: 25,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
