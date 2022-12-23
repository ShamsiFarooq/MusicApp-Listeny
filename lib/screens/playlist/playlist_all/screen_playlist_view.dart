import 'package:flutter/material.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/db/db_model/playlist_model/playlist_model.dart' as pd;
import 'package:listeny/screens/playlist/playlist_all/screen_add_songs.dart';
import 'package:listeny/screens/playlist/playlist_all/screen_playlist_play.dart';
import 'package:listeny/style/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<MusicModel> allPlaylistSongs = [];

class ScreenPlaylistView extends StatefulWidget {
  final pd.PlaylistModel playlistData;
  final int index;
  const ScreenPlaylistView(
      {super.key, required this.playlistData, required this.index});

  @override
  State<ScreenPlaylistView> createState() => _ScreenPlaylistViewState();
}

class _ScreenPlaylistViewState extends State<ScreenPlaylistView> {
  bool _visible = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    listPlaylist();
    controller.text = widget.playlistData.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: widget.playlistData.songIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  noSongsText(),
                  height15,
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ScreenAddSongs(
                                index: widget.index,
                                playlist: widget.playlistData)));
                        setState(() {
                          listPlaylist();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color2,
                      ),
                      child: const Text("Add Songs"),
                    ),
                  )
                ],
              ),
            )
          : listViewSection(),
    );
  }

  ListView listViewSection() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ScreenPlaylistPlay(
                  index: index,
                  playlistData: widget.playlistData,
                  allSongs: allPlaylistSongs,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: Row(
              children: [
                songImage(audio.indexOf(allPlaylistSongs[index])),
                width15,
                songDetails(index),
                deleteSongButton(index, context)
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => seperatorWidet(),
      itemCount: allPlaylistSongs.length,
    );
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: color4,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Text(
        widget.playlistData.name,
         style: TextStyle(fontSize: 35, color: color4, fontFamily: 'Caveat'),
      ),
      backgroundColor: color2,
      actions: [
        IconButton(
            onPressed: () {
              editPlaylistDialog();
            },
            icon: Icon(
              Icons.edit,
              color: color4,
            ))
      ],
    );
  }

  Text noSongsText() {
    return Text(
      "No songs added yet",
      style: TextStyle(color: color4, fontSize: 20),
    );
  }

  SizedBox songImage(index) {
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

  Expanded songDetails(int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            allPlaylistSongs[index].title!,
            style: TextStyle(fontSize: 15, color: color4),
          ),
          Text(
            allPlaylistSongs[index].artist == '<unknown>'
                ? 'Unknown Artist'
                : allPlaylistSongs[index].artist!,
            style: TextStyle(fontSize: 11, color: color3),
          )
        ],
      ),
    );
  }

  IconButton deleteSongButton(int index, BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.playlistData.deleteData(allPlaylistSongs[index].id, context);
          setState(() {
            listPlaylist();
          });
        },
        icon: Icon(
          Icons.delete,
          color:color4,
        ));
  }

  Padding seperatorWidet() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Divider(
        color: Color(0xFF1A2123),
      ),
    );
  }

  listPlaylist() {
    allPlaylistSongs = [];
    for (int i = 0; i < widget.playlistData.songIds.length; i++) {
      for (int j = 0; j < musicNotifier.value.length; j++) {
        if (widget.playlistData.songIds[i] == musicNotifier.value[j].id) {
          allPlaylistSongs.add(musicNotifier.value[j]);
        }
      }
    }
  }

  indexFinder(MusicModel data) {
    List<MusicModel> list = musicNotifier.value;
    return list.indexOf(data);
  }

  editPlaylistDialog() {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: color2,
            title: Center(
              child: Text(
                'Edit Playlist',
                style: TextStyle(color: color4),
              ),
            ),
            content: SizedBox(
              height: 90,
              child: Column(
                children: [
                  Visibility(
                      visible: _visible,
                      child: const Text(
                        'Cannot be empty',
                        style: TextStyle(color: Colors.red),
                      )),
                  height15,
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      label: Text(
                        'Playlist Name',
                        style: TextStyle(color: color4),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: color3)),
                    ),
                    style: TextStyle(color: color4),
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color3,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: color1),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color3,
                  ),
                  child: Text(
                    'Ok',
                    style: TextStyle(color: color1),
                  ),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      _visible = true;
                      Navigator.of(context).pop();
                      editPlaylistDialog();
                    } else {
                      _visible = false;
                      updatePlaylist(widget.index, controller.text, context);
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                ),
              )
            ],
          );
        });
  }
}
