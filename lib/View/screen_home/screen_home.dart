// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:listeny/Controller/favorite/favorite_bloc.dart';
import 'package:listeny/Controller/home/home_bloc.dart';
import 'package:listeny/Model/music_model.dart';
import 'package:listeny/View/screen_add_to_playlist/screen_add_to_playlist.dart';
import 'package:listeny/View/screen_play/screen_play.dart';
import 'package:listeny/View/screen_settings/settings/settings_screen.dart';
import 'package:listeny/View/widgets/logo.dart';
import 'package:listeny/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => BlocProvider.of<HomeBloc>(context).add(GetAllMusic()),
    );
    permissionHandle(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topLogo(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: musicsList(),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: const FloatingAction(),
    );
  }

  musicsList() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.musics.isEmpty) {
          return noSongWidget();
        }
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: themeColor,
          ),
          itemCount: state.musics.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await audioPlayer.stop();
                audio = state.musics;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ScreenPlay(
                      index: index,
                      songs: const [],
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    musicImage(state.musics[index].id),
                    kWidth20,
                    Expanded(child: musicDetails(state.musics, index)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        favButton(index, state.musics[index], context),
                        playlistButton(state.musics[index].id, context)
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  permissionHandle(context) async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
      BlocProvider.of<HomeBloc>(context).add(GetAllMusic());
    }
  }

  Center noSongWidget() {
    return const Center(
        child: Text(
      'No Songs found',
      style: TextStyle(color: textColor, fontSize: 20),
    ));
  }

  IconButton playlistButton(int songID, BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => AddToPlaylist(
                  id: songID,
                )));
      },
      icon: const Icon(
        Icons.playlist_add,
        size: 30,
      ),
      color: textColor,
    );
  }

  Padding topLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.music_note,
            color: themeColor,
            size: 45,
          ),
          kWidth10,
          Expanded(child: logoText()),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ScreenSettings(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }

  musicImage(id) {
    return SizedBox(
      height: 75,
      width: 75,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: QueryArtworkWidget(
          id: id,
          artworkQuality: FilterQuality.high,
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.zero,
          artworkFit: BoxFit.cover,
          nullArtworkWidget: Image.asset('assets/img/Listeny.png'),
        ),
      ),
    );
  }

  favButton(int index, MusicModel value, BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            BlocProvider.of<FavoriteBloc>(context)
                .add(FavoriteAddRemove(id: value.id));
          },
          icon: Icon(
            value.isFav ? Icons.favorite : Icons.favorite_outline,
            color: themeColor,
          ),
        );
      },
    );
  }

  Column musicDetails(List<MusicModel> value, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value[index].title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, color: textColor),
        ),
        Text(
          value[index].album!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: authColor),
        )
      ],
    );
  }
}
