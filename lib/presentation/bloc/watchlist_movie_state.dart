part of 'watchlist_movie_bloc.dart';

@immutable
abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieInitial extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieLoaded extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;
  WatchlistMovieError(this.message);

  @override
  List<Object> get props => [];
}
