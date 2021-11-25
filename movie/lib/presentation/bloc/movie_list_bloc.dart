import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/movie.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetPopularMovies _getPopularMovies;
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetTopRatedMovies _getTopRatedMovies;

  MovieListBloc(
    this._getPopularMovies,
    this._getNowPlayingMovies,
    this._getTopRatedMovies,
  ) : super(MovieListInitial());

  List<Movie> _nowPlayingMovie = [];
  List<Movie> _topRatedMovie = [];
  List<Movie> _popularMovie = [];

  List<Movie> get nowPlayingMovie => _nowPlayingMovie;
  List<Movie> get topRatedMovie => _topRatedMovie;
  List<Movie> get popularMovie => _popularMovie;

  @override
  Stream<MovieListState> mapEventToState(
    MovieListEvent event,
  ) async* {
    if (event is LoadMovieList) {
      yield MovieListLoading();
      final getNowPlayingMovie = await _getNowPlayingMovies.execute();
      final getPopularMovie = await _getPopularMovies.execute();
      final getTopRatedMovie = await _getTopRatedMovies.execute();

      yield* getNowPlayingMovie.fold(
        (failure) async* {
          yield MovieListError(failure.message);
        },
        (nowPlaying) async* {
          _nowPlayingMovie = nowPlaying;
          yield* getPopularMovie.fold(
            (failure) async* {
              yield MovieListError(failure.message);
            },
            (popular) async* {
              _popularMovie = popular;
              yield* getTopRatedMovie.fold(
                (failure) async* {
                  yield MovieListError(failure.message);
                },
                (topRated) async* {
                  _topRatedMovie = topRated;
                  yield MovieListLoaded();
                },
              );
            },
          );
        },
      );
    }
  }
}
