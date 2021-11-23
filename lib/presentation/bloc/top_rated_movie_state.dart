part of 'top_rated_movie_bloc.dart';

@immutable
abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();

  @override
  List<Object> get props => [];
}

class TopRatedMovieInitial extends TopRatedMovieState {}
class TopRatedMovieLoading extends TopRatedMovieState {}
class TopRatedMovieLoaded extends TopRatedMovieState {}
class TopRatedMovieError extends TopRatedMovieState {
  final String message;
  TopRatedMovieError(this.message);

  @override
  List<Object> get props => [];
}
