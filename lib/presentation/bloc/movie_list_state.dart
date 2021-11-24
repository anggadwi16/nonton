part of 'movie_list_bloc.dart';

@immutable
abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListLoaded extends MovieListState {}

class MovieListError extends MovieListState {
  final String message;
  MovieListError(this.message);

  @override
  List<Object> get props => [message];
}
