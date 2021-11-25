import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/movie.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;
  PopularMovieBloc(this._getPopularMovies) : super(PopularMovieInitial());

  late List<Movie> _popular;
  List<Movie> get popular => _popular;

  @override
  Stream<PopularMovieState> mapEventToState(
    PopularMovieEvent event,
  ) async* {
    if (event is LoadPopularMovie) {
      yield PopularMovieLoading();
      final getNowPlayingMovie = await _getPopularMovies.execute();
      yield* getNowPlayingMovie.fold(
        (failure) async* {
          yield PopularMovieError(failure.message);
        },
        (data) async* {
          _popular = data;
          yield PopularMovieLoaded();
        },
      );
    }
  }
}
