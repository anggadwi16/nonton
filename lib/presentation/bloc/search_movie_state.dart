part of 'search_movie_bloc.dart';

@immutable
abstract class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

class SearchMovieInitial extends SearchMovieState {}
class SearchMovieLoading extends SearchMovieState {}
class SearchMovieLoaded extends SearchMovieState {}
class SearchMovieError extends SearchMovieState {
  final String message;
  SearchMovieError(this.message);

  @override
  List<Object> get props => [message];
}
