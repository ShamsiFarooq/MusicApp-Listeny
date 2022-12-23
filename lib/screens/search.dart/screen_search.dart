import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/screens/home/home_screen.dart';
import 'package:listeny/screens/playing_screen/playing_screen.dart';
import 'package:listeny/screens/search.dart/widgets/image_widget.dart';
import 'package:listeny/screens/search.dart/widgets/index_finder.dart';
import 'package:listeny/screens/search.dart/widgets/no_songs.dart';
import 'package:listeny/screens/search.dart/widgets/title_author.dart';
import 'package:listeny/screens/widgets/list_view_divider.dart';
import 'package:listeny/style/constant.dart';

class ScreenSearch extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const ScreenSearch({super.key, required this.audioPlayer});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  List<MusicModel> allList = [];
  List<MusicModel> foundList = [];

  @override
  void initState() {
    allList.addAll(musicNotifier.value);
    if (foundList.isEmpty) {
      foundList = allList;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: headText(text: 'Search'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx1) => HomeScreen(audioPlayer: audioPlayer)));
            },
            icon: Icon(Icons.arrow_back_ios_new_sharp)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height15,
            searchTextField(),
            Expanded(
              child: foundList.isEmpty ? noSongsWidget() : searchedList(),
            ),
          ],
        ),
      ),
    );
  }

  ListView searchedList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        ScreenPlay(index: indexFinder(foundList[index])))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: Row(
                children: [
                  imageWidget(audio.indexOf(foundList[index])),
                  width15,
                  titleAndAuthor(index, foundList),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => listViewDivider(),
        itemCount: foundList.length);
  }

  Text headText({required String text}) {
    return Text(
      text,
      style: TextStyle(fontSize: 35, color: color4, fontFamily: 'Caveat'),
    );
  }

  Padding searchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        style: TextStyle(color: color4),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color4),
            borderRadius: BorderRadius.circular(10),
          ),
          label: Text(
            "Search",
            style: TextStyle(color: color3),
          ),
          suffixIcon: Icon(
            Icons.search,
            color: color4,
            size: 30,
          ),
        ),
        onChanged: (value) => searchWidget(value),
      ),
    );
  }

  searchWidget(value) {
    List<MusicModel> result = [];
    if (value.isEmpty) {
      result = allList;
    } else {
      result = allList
          .where(
            (element) => element.title!.toLowerCase().trim().contains(value),
          )
          .toList();
    }

    setState(() {
      foundList = result;
    });
  }
}
