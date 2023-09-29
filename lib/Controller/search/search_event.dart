part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchQuery extends SearchEvent {
  final String query;
  SearchQuery({required this.query});
}
