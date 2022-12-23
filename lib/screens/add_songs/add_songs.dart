import 'package:flutter/material.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/screens/widgets/list_view_divider.dart';
import 'package:listeny/style/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenAddSongs extends StatefulWidget {
  final int index;
  final PlaylistModel playlist;
  const ScreenAddSongs(
      {super.key, required this.index, required this.playlist});

  @override
  State<ScreenAddSongs> createState() => _ScreenAddSongsState();
}

class _ScreenAddSongsState extends State<ScreenAddSongs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: musicNotifier,
          builder: (context, value, child) {
            if (value.isEmpty) {
              return noSongsWidget();
            }
            return ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15),
                    child: Row(
                      children: [
                        imageWidget(),
                        width15,
                        titleAndAuthor(value, index),
                        Row(
                          children: [
                            favButton(value, index),
                            width15,
                            addingButton(value, index, context)
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => listViewDivider(),
                itemCount: value.length);
          },
        ),
      ),
    );
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left)),
      title: Text('Add Songs'),
      backgroundColor: color1,
      elevation: 0,
    );
  }

  Center noSongsWidget() {
    return  Center(
      child: Text(
        'No Songs to add',
        style: TextStyle(
          color: color4,
        ),
      ),
    );
  }

  IconButton addingButton(
      List<MusicModel> value, int index, BuildContext context) {
    return IconButton(
        onPressed: () {
          // if (widget.playlist.songIds.contains(value[index].id)) {
          //   widget.playlist.deleteData(value[index].id, context);
          // } else {
          //   widget.playlist.addData(value[index].id, context);
          // }
          // setState(() {});
        },
        icon: const Icon(
          // widget.playlist.songIds.contains(value[index].id)
          //     ? Icons.playlist_add_check
          //     : 
              Icons.playlist_add,
          // color: widget.playlist.songIds.contains(value[index].id)
          //     ? Colors.green
          //     : color4,
          // size: 30,
        ));
  }

  Container imageWidget() {
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/img/ListenyLogo1.png'),
        ),
      ),
    );
  }

  Expanded titleAndAuthor(value, index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value[index].title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style:  TextStyle(fontSize: 15, color: color4),
          ),
          Text(
            value[index].artist,
            style:  TextStyle(fontSize: 11, color: color4),
          )
        ],
      ),
    );
  }

  IconButton favButton(value, index) {
    return IconButton(
      onPressed: () {
        // favOption(value[index].id, context);
        // setState(() {});
      },
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: color3,
        size: 30,
      ),
    );
  }
}
