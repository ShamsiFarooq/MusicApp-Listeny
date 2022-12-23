

import 'package:listeny/db/db_function/db_function.dart';
import 'package:listeny/db/db_model/music_model.dart';

indexFinder(MusicModel data) {
  List<MusicModel> list = musicNotifier.value;
  return list.indexOf(data);
}
