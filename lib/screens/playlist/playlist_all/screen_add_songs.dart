import 'package:flutter/material.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/db/db_model/playlist_model/playlist_model.dart' as pd;
import 'package:listeny/screens/widgets/list_view_divider.dart';
import 'package:listeny/style/constant.dart';

class ScreenAddSongs extends StatefulWidget {
  final int index;
  final pd.PlaylistModel playlist;
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
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20),
                        
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
          icon:  Icon(Icons.chevron_left, color: color4,)),
      title:  Text('Add Songs', style: TextStyle(color: color4),),
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
          if (widget.playlist.songIds.contains(value[index].id)) {
            widget.playlist.deleteData(value[index].id, context);
          } else {
            widget.playlist.addData(value[index].id, context);
          }
          setState(() {});
        },
        icon: Icon(
          widget.playlist.songIds.contains(value[index].id)
              ? Icons.playlist_add_check
              : Icons.playlist_add,
          color: widget.playlist.songIds.contains(value[index].id)
              ? Colors.green
              : color4,
          size: 30,
        ));
  }

  Container imageWidget() {
    return Container(
      height: 50,
      width: 50,
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
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(fontSize: 11, color: color3),
          )
        ],
      ),
    );
  }

  IconButton favButton(value, index) {
    return IconButton(
      onPressed: () {
        favOption(value[index].id, context);
        setState(() {});
      },
      icon: Icon(
        value[index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: color4,
        size: 30,
      ),
    );
  }
}
