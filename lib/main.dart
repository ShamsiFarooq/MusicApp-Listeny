import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:listeny/Controller/bottom_nav/bottom_nav_bloc.dart';
import 'package:listeny/Controller/favorite/favorite_bloc.dart';
import 'package:listeny/Controller/home/home_bloc.dart';
import 'package:listeny/Controller/most_played/most_played_bloc.dart';
import 'package:listeny/Controller/playing/playing_bloc.dart';
import 'package:listeny/Controller/playlist/playlist_bloc.dart';
import 'package:listeny/Controller/recent/recent_bloc.dart';
import 'package:listeny/Controller/search/search_bloc.dart';
import 'package:listeny/Model/music_model.dart';
import 'package:listeny/Model/playlist_model/playlist_model.dart';
import 'package:listeny/Model/recent_model/recent_model.dart';
import 'package:listeny/View/screen_splash/screen_splash.dart';
import 'package:listeny/constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistModelAdapter());
  }
  if (!Hive.isAdapterRegistered(RecentModelAdapter().typeId)) {
    Hive.registerAdapter(RecentModelAdapter());
  }
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => PlaylistBloc(),
        ),
        BlocProvider(
          create: (context) => PlayingBloc(),
        ),
        BlocProvider(
          create: (context) => RecentBloc(),
        ),
        BlocProvider(
          create: (context) => MostPlayedBloc(),
        ),
        BlocProvider(
          create: (context) => BottomNavBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ScreenSplash(),
        theme: ThemeData(
          scaffoldBackgroundColor: bgPrimary,
          primaryColor: themeColor,
        ),
      ),
    );
  }
}
