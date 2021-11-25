part of 'search_tv_bloc.dart';

@immutable
abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class OnChangeSearch extends SearchTvEvent {
  final String query;
  OnChangeSearch(this.query);

  @override
  List<Object> get props => [query];
}
