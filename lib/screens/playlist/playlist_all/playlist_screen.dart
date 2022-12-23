// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/playlist_model/playlist_model.dart';
import 'package:listeny/screens/playlist/mostly_played.dart';
import 'package:listeny/screens/playlist/playlist_all/screen_playlist_view.dart';
import 'package:listeny/screens/playlist/recently_played.dart';
import 'package:listeny/style/constant.dart';

bool isVisible = false;

class ScreenPlaylist extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const ScreenPlaylist({super.key, required this.audioPlayer});

  @override
  State<ScreenPlaylist> createState() => _ScreenPlaylistState();
}

class _ScreenPlaylistState extends State<ScreenPlaylist> {
  ValueNotifier<List<PlaylistModel>> list = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    getValuesFromDatabase();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height15,
            headText(text: 'Playlists'),
            height15,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ValueListenableBuilder(
                  valueListenable: list,
                  builder: (context, List<PlaylistModel> value, child) {
                    getValuesFromDatabase();
                    if (value.isEmpty) {
                      return noPlaylistMessge();
                    }
                    return playlists(value);
                  },
                ),
              ),
            ),
            height15,
            buttonWidget('Most Played', const ScreenMostPlayed(), context),
            height15,
            buttonWidget(
                'Recently Played', const ScreenRecentPlayed(), context),
            height30,
            height30,
          ],
        ),
      ),
      floatingActionButton: addButton(context),
    );
  }

  FloatingActionButton addButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color2,
      onPressed: () {
        addPlaylistPopUP(context);
      },
      child: Icon(
        Icons.add,
        color: color3,
      ),
    );
  }

  GridView playlists(List<PlaylistModel> value) {
    return GridView.builder(
      itemCount: value.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 150,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ScreenPlaylistView(
                playlistData: value[index],
                index: index,
              ),
            ),
          ),
          child: Column(
            children: [
              Stack(children: [
                playlistImage(),
                playlistDelete(value, index),
              ]),
              playlistName(value, index)
            ],
          ),
        );
      },
    );
  }

  getValuesFromDatabase() async {
    final db = await Hive.openBox<PlaylistModel>('playlists');
    list.value.clear();
    list.value.addAll(db.values);
    list.notifyListeners();
  }

  buttonWidget(data, event, context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color2),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => event));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data,
                style: TextStyle(fontSize: 18, color: color4),
              ),
              Icon(
                Icons.chevron_right,
                color: color3,
              )
            ],
          ),
        ),
      ),
    );
  }

  Center noPlaylistMessge() {
    return Center(
      child: Text(
        "No Playlist Created yet",
        style: TextStyle(
          color: color4,
          fontSize: 20,
        ),
      ),
    );
  }

  Text headText({required String text}) {
    return Text(
      text,
      style: TextStyle(fontSize: 35, color: color4, fontFamily: 'Caveat'),
    );
  }

  Text playlistName(List<PlaylistModel> value, int index) {
    return Text(
      value[index].name,
      style: TextStyle(color: color4, fontSize: 20),
    );
  }

  Positioned playlistDelete(List<PlaylistModel> value, int index) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: IconButton(
        onPressed: () {
          deletePlaylistDialog(value[index].name, index);
        },
        icon: Icon(
          Icons.delete,
          color: color4,
        ),
      ),
    );
  }

  Container playlistImage() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage(
            'assets/img/download.jpeg',
          ),
        ),
      ),
    );
  }

  deletePlaylistDialog(playlist, index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: color2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Are You Sure!!!',
            style: TextStyle(color: color4),
          ),
          content: Text(
            'Do you want to delete the playlist $playlist',
            style: TextStyle(color: color4),
          ),
          actions: [
            SizedBox(
              width: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: color1),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: color4),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: color1),
                child: const Text('Delete'),
                onPressed: () {
                  deletePlaylist(index, context);
                  setState(() {});

                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  addPlaylistPopUP(ctx) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: ctx,
        builder: ((context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: color2,
            title: Center(
              child: Text(
                "Create New Playlist",
                style: TextStyle(color: color4),
              ),
            ),
            content: SizedBox(
              height: 90,
              child: Column(
                children: [
                  Visibility(
                    visible: isVisible,
                    child: const Text(
                      'Cannot be empty',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  height15,
                  TextField(
                    controller: controller,
                    style: TextStyle(color: color4),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: color3)),
                      label: Text(
                        "Playlist Name",
                        style: TextStyle(color: color3.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              width15,
              playListAddButtons(
                  context: context, color: color1, data: "Cancel", func: 0),
              width15,
              playListAddButtons(
                  context: context,
                  color: color3,
                  data: "Add",
                  func: 1,
                  controller: controller),
              width15,
            ],
          );
        }));
  }

  SizedBox playListAddButtons({
    required BuildContext context,
    required Color color,
    required String data,
    required func,
    controller,
  }) {
    return SizedBox(
      width: 115,
      child: ElevatedButton(
        onPressed: () {
          if (func == 0) {
            Navigator.of(context).pop();
            isVisible = false;
          } else {
            if (controller.text.isEmpty || controller.text == null) {
              setState(() {
                isVisible = true;
                Navigator.of(context).pop();
                addPlaylistPopUP(context);
              });
            } else {
              setState(() {
                isVisible = false;
                Navigator.of(context).pop();
                addPlaylistPopUP(context);
              });
              final value = PlaylistModel(name: controller.text, songIds: []);
              addPlaylist(value, context);
              Navigator.of(context).pop();
            }
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(
          data,
          style: TextStyle(color: color4),
        ),
      ),
    );
  }
}
