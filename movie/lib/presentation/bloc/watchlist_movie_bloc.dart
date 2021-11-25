import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/movie.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  WatchlistMovieBloc(this._getWatchlistMovies) : super(WatchlistMovieInitial());

  List<Movie> _watchlistMovie = [];
  List<Movie> get watchlistMovie => _watchlistMovie;

  @override
  Stream<WatchlistMovieState> mapEventToState(
    WatchlistMovieEvent event,
  ) async* {
    if (event is LoadWatchlistMovie) {
      yield WatchlistMovieLoading();
      final getWatchlistMovie = await _getWatchlistMovies.execute();
      yield* getWatchlistMovie.fold(
        (failure) async* {
          yield WatchlistMovieError(failure.message);
        },
        (data) async* {
          _watchlistMovie = data;
          yield WatchlistMovieLoaded();
        },
      );
    }
  }
}
