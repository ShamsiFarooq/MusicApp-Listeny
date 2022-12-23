import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/db/db_model/playlist_model/playlist_model.dart' as pd;
import 'package:listeny/screens/playlist/playlist_all/screen_list_song.dart';
import 'package:listeny/style/constant.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class ScreenPlaylistPlay extends StatefulWidget {
  int index;
  final pd.PlaylistModel playlistData;
  final List<MusicModel> allSongs;
  ScreenPlaylistPlay(
      {super.key,
      required this.index,
      required this.playlistData,
      required this.allSongs});

  @override
  State<ScreenPlaylistPlay> createState() => _ScreenPlaylistPlayState();
}

class _ScreenPlaylistPlayState extends State<ScreenPlaylistPlay> {
  List<SongModel> playlistSongs = [];

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
    await playlistToSongModel();
    await audioPlayer.setAudioSource(createSongList(playlistSongs),
        initialIndex: widget.index);
    setState(() {
      audioPlayer.play();
    });
    isPlaying.value = true;
    isPlaying.notifyListeners();
    _isPlaying = true;
    audioPlayer.playingStream.listen((event) {
      if (event) {
        addToRecent(widget.allSongs[widget.index].id);
      }
    });
    audioPlayer.durationStream.listen((event) {
      dur = event;
    });
    audioPlayer.positionStream.listen((event) async {
      // ignore: prefer_const_constructors
      if (event == dur && dur != Duration()) {
        if (audioPlayer.hasNext) {
          widget.index += 1;
          audioPlayer.pause();
          audioPlayer.seekToNext();
          _isPlaying = true;
          await audioPlayer.play();
          setState(() {});
        } else {
          _isPlaying = true;
          audioPlayer.play();
        }
      }
    });
  }

  playlistToSongModel() async {
    final List<SongModel> playlist = [];
    final audioQuery = OnAudioQuery();
    final songs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for (var song in widget.playlistData.songIds) {
      final temp = songs.where((element) => element.id == song).toList()[0];
      playlist.add(temp);
    }
    playlistSongs = playlist;
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon:  Icon(Icons.chevron_left, color: color4),
      ),
      backgroundColor: color2,
      elevation: 0,
      title: Text('Playlist : ${widget.playlistData.name}',
      style: TextStyle(fontSize: 35, color: color4, fontFamily: 'Caveat'),),
      actions: [
        addPlaylistButton(context),
      ],
    );
  }

  Padding addPlaylistButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon:  Icon(
          Icons.playlist_add,
          size: 30,
          color: color4,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AddToPlaylist(
                    id: widget.allSongs[widget.index].id,
                  )));
        },
      ),
    );
  }

  Expanded musicDetails() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [songImage(), height15, songDetails()],
        ),
      ),
    );
  }

  SizedBox songImage() {
    return SizedBox(
      height: 250,
      width: 250,
      child: QueryArtworkWidget(
        id: widget.allSongs[widget.index].id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset('assets/img/ListenyLogo1.png'),
      ),
    );
  }

  Column songDetails() {
    return Column(
      
      children: [
        Text(
          widget.allSongs[widget.index].title!,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: TextStyle(fontSize: 20, color: color4),
        ),
        Text(
          widget.allSongs[widget.index].artist == "<unknown>"
              ? "Unknown Artist"
              : widget.allSongs[widget.index].artist!,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: TextStyle(fontSize: 15, color: color3),
        ),
      ],
    );
  }

  Container bottomControlsBar() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        color: color1,
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
                      ? await audioPlayer.setLoopMode(LoopMode.all)
                      : await audioPlayer.setLoopMode(LoopMode.one);
                },
                icon: Icon(
                  Icons.repeat_outlined,
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
        favOption(widget.allSongs[widget.index].id, context);
        setState(() {});
      },
      icon: Icon(
        widget.allSongs[widget.index].isFav
            ? Icons.favorite
            : Icons.favorite_outline,
        color: color4,
      ),
    );
  }

  IconButton previousSongButton() {
    return IconButton(
      onPressed: () async {
        if (audioPlayer.hasPrevious) {
          audioPlayer.pause();
          await audioPlayer.seekToPrevious();
          audioPlayer.play();
          widget.index -= 1;
          _isPlaying = true;

          setState(() {
            musicDetails();
          });
        } else {
          audioPlayer.play;
          _isPlaying = true;
        }
      },
      icon: Icon(
        Icons.skip_previous,
        size: 35,
        color: audioPlayer.hasPrevious ? color4 : color2,
      ),
    );
  }

  CircleAvatar pauseAndPlayButton() {
    return CircleAvatar(
      radius: 30,
      //backgroundColor: const Color(0xFF212A2D),
      child: Center(
        child: CircleAvatar(
          radius: 30,
          backgroundColor:color4,
          child: Center(
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: color1,
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
      },
      icon: Icon(
        Icons.skip_next,
        size: 35,
        color: audioPlayer.hasNext ? color4 : color2,
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
                    color: color1, fontWeight: FontWeight.bold, fontSize: 15),
                progress: progress,
                total: total,
                // barHeight: 3.0,
                // thumbRadius: 5,
                progressBarColor: color4,
                thumbColor: color4,
                baseBarColor:color2,
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
