import 'package:hive_flutter/adapters.dart';
import 'package:listeny/Model/music_model.dart';

indexFinder(MusicModel data) async {
  final db = await Hive.openBox<MusicModel>('musics');
  return db.values.toList().indexOf(data);
}
