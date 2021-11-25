part of 'search_movie_bloc.dart';

@immutable
abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class OnChangeSearchMovie extends SearchMovieEvent {
  final String query;
  OnChangeSearchMovie(this.query);

  @override
  List<Object> get props => [query];
}
