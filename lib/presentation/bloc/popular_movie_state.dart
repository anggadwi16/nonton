part of 'popular_movie_bloc.dart';

@immutable
abstract class PopularMovieState extends Equatable {
  const PopularMovieState();
  @override
  List<Object> get props => [];
}

class PopularMovieInitial extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieLoaded extends PopularMovieState {}

class PopularMovieError extends PopularMovieState {
  final String message;
  PopularMovieError(this.message);

  @override
  List<Object> get props => [];
}
