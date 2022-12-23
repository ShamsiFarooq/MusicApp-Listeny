// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/screens/playlist/playlist_all/screen_list_song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../style/constant.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class ScreenPlay extends StatefulWidget {
  int index;
  List<SongModel> songs = [];
  ScreenPlay({
    super.key,
    required this.index,
  });

  @override
  State<ScreenPlay> createState() => _ScreenPlayState();
}

class _ScreenPlayState extends State<ScreenPlay> {
  // ignore: prefer_const_constructors
  Duration? dur = Duration();
  bool _isPlaying = false;

  @override
  void initState() {
    playSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarWidget(context),
      body: Column(
        children: [
          musicDetails(),
          bottomControlsBar(),
        ],
      ),
    );
  }

  playSong() async {
    await getSongs();
    await audioPlayer.setAudioSource(createSongList(widget.songs),
        initialIndex: widget.index);
    setState(() {
      audioPlayer.play();
    });
    isPlaying.value = true;
    isPlaying.notifyListeners();
    _isPlaying = true;
    audioPlayer.playingStream.listen((event) {
      if (event) {
        addToRecent(audio[widget.index].id);
      }
    });
    audioPlayer.durationStream.listen((event) {
      dur = event;
    });
    audioPlayer.positionStream.listen((event) async {
      if (event == dur &&
          // ignore: prefer_const_constructors
          dur != Duration() &&
          audioPlayer.loopMode != LoopMode.one) {
        if (audioPlayer.hasNext) {
          widget.index += 1;
          audioPlayer.pause();
          await audioPlayer.seekToNext();
          _isPlaying = true;
          audioPlayer.play();
          setState(() {});
        } else {
          _isPlaying = true;
          audioPlayer.play();
        }
      }
    });
  }

  getSongs() async {
    final audioQuery = OnAudioQuery();
    final songs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    List<SongModel> song = [];
    final prefs = await SharedPreferences.getInstance();
    final bool? filter = prefs.getBool('filter');
    if (filter == true) {
      song =
          songs.where((element) => element.album != 'WhatsApp Audio').toList();
    } else {
      song = songs;
    }
    widget.songs = song;
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.chevron_left),
      ),
      backgroundColor: color2,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            audio[widget.index].title!,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: TextStyle(fontSize: 15, color: color4),
          ),
          Text(
            audio[widget.index].artist == "<unknown>"
                ? "Unknown Artist"
                : audio[widget.index].artist!,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: TextStyle(fontSize: 11, color: color3),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.playlist_add,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddToPlaylist(
                    id: audio[widget.index].id,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Expanded musicDetails() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [musicImage(), height30, songDetails()],
        ),
      ),
    );
  }

  Column songDetails() {
    return Column(
      children: [
        Text(
          audio[widget.index].title!,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: TextStyle(fontSize: 20, color: color4),
        ),
        Text(
          audio[widget.index].artist == "<unknown>"
              ? "Unknown Artist"
              : audio[widget.index].artist!,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: TextStyle(fontSize: 15, color: color3),
        ),
      ],
    );
  }

  SizedBox musicImage() {
    return SizedBox(
      height: 250,
      width: 250,
      child: QueryArtworkWidget(
        id: audio[widget.index].id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset('assets/img/ListenyLogo1.png'),
      ),
    );
  }

  Container bottomControlsBar() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        color: color2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              favoriteButton(),
              reverse10sec(),
              previousSongButton(),
              pauseAndPlayButton(),
              nextSongButton(),
              skip10sec(),
              IconButton(
                onPressed: () async {
                  audioPlayer.loopMode == LoopMode.one
                      ? await audioPlayer.setLoopMode(LoopMode.off)
                      : await audioPlayer.setLoopMode(LoopMode.one);
                  setState(() {});
                },
                icon: Icon(
                  audioPlayer.loopMode == LoopMode.one
                      ? Icons.repeat_one
                      : Icons.repeat_outlined,
                  color: color4,
                ),
              ),
            ],
          ),
          Column(
            children: [
              sliderMethod(),
            ],
          )
        ],
      ),
    );
  }

  reverse10sec() {
    return IconButton(
      onPressed: () {
        // ignore: prefer_const_constructors
        var x = audioPlayer.position + Duration(seconds: -10);
        if (x.isNegative) {
          // ignore: prefer_const_constructors
          audioPlayer.seek(Duration(seconds: 0));
        } else {
          audioPlayer.seek(x);
        }
      },
      icon: Icon(
        Icons.replay_10,
        color: color4,
        size: 30,
      ),
    );
  }

  skip10sec() {
    return IconButton(
      onPressed: () {
        // ignore: prefer_const_constructors
        var x = audioPlayer.position + Duration(seconds: 10);
        if (x > dur!) {
          // ignore: prefer_const_constructors
          audioPlayer.seek(dur! - Duration(milliseconds: 250));
        } else {
          audioPlayer.seek(x);
        }
      },
      icon: Icon(
        Icons.forward_10,
        color: color4,
        size: 30,
      ),
    );
  }

  IconButton favoriteButton() {
    return IconButton(
      onPressed: () {
        favOption(audio[widget.index].id, context);
        setState(() {});
      },
      icon: Icon(
        audio[widget.index].isFav ? Icons.favorite : Icons.favorite_outline,
        color: color4,
      ),
    );
  }

  IconButton previousSongButton() {
    return IconButton(
      onPressed: () async {
        if (audioPlayer.hasPrevious && audioPlayer.loopMode != LoopMode.one) {
          audioPlayer.pause();
          await audioPlayer.seekToPrevious();
          audioPlayer.play();
          widget.index -= 1;
          _isPlaying = true;

          setState(() {
            musicDetails();
          });
        } else {
          _isPlaying = true;
        }
      },
      icon: Icon(
        Icons.skip_previous,
        size: 35,
        color: audioPlayer.hasPrevious ? color4 : Colors.grey.withOpacity(0.5),
      ),
    );
  }

  CircleAvatar pauseAndPlayButton() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: const Color(0xFF212A2D),
      child: Center(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: color3,
          child: Center(
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: color4,
                size: 30,
              ),
              onPressed: () {
                if (_isPlaying) {
                  audioPlayer.pause();
                } else {
                  audioPlayer.play();
                }
                setState(
                  () {
                    isPlaying.value = !isPlaying.value;
                    // ignore: invalid_use_of_protected_member
                    isPlaying.notifyListeners();
                    _isPlaying = !_isPlaying;
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  IconButton nextSongButton() {
    return IconButton(
      onPressed: () async {
        if (audioPlayer.hasNext && audioPlayer.loopMode != LoopMode.one) {
          widget.index += 1;
          audioPlayer.pause();
          await audioPlayer.seekToNext();
          audioPlayer.play();
          _isPlaying = true;

          setState(() {});
        } else {
          _isPlaying = true;
        }
      },
      icon: Icon(
        Icons.skip_next,
        size: 35,
        color: audioPlayer.hasNext ? color4 : Colors.grey.withOpacity(0.5),
      ),
    );
  }

  sliderMethod() {
    return StreamBuilder<DurationState>(
        stream: _durationStateStream,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.position ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ProgressBar(
                timeLabelTextStyle: TextStyle(
                    color: color4, fontWeight: FontWeight.bold, fontSize: 15),
                progress: progress,
                total: total,
                // barHeight: 3.0,
                // thumbRadius: 5,
                progressBarColor: color3,
                thumbColor: color3,
                baseBarColor: color4,
                onSeek: (duration) {
                  audioPlayer.seek(duration);
                }),
          );
        });
  }
}

Stream<DurationState> get _durationStateStream =>
    Rx.combineLatest2<Duration, Duration?, DurationState>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (position, duration) => DurationState(
            position: position, total: duration ?? Duration.zero));

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
