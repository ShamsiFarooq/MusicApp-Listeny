
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:listeny/db/db_model/music_model.dart';
import 'package:listeny/db/db_model/playlist_model/playlist_model.dart';
import 'package:listeny/db/db_model/recent_model/recent_model.dart';

import 'package:listeny/screens/screen_main/splash.dart';
import 'package:listeny/style/constant.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  } if (!Hive.isAdapterRegistered(PlaylistModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistModelAdapter());
  }
  if (!Hive.isAdapterRegistered(RecentModelAdapter().typeId)) {
    Hive.registerAdapter(RecentModelAdapter());
  }
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listeny',
      theme: ThemeData(
        iconTheme: IconThemeData(color:color4),
        scaffoldBackgroundColor: color1,
        primaryColor: color1,
        appBarTheme:AppBarTheme(backgroundColor: color2),
        tabBarTheme:TabBarTheme(labelColor: color4, unselectedLabelColor: color3),
      
      ),
      
      home: const SplashScreen(),
    );
  }
}

