import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:listeny/Model/music_model.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQuery>((event, emit) async {
      final musicDb = await Hive.openBox<MusicModel>('musics');
      final result = musicDb.values
          .where(
            (element) => element.name!
                .toLowerCase()
                .contains(event.query.toLowerCase().trim()),
          )
          .toList();
      emit(SearchState(result: result));
    });
  }
}
