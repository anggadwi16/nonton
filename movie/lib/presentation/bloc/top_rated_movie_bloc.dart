import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/movie.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;
  TopRatedMovieBloc(this._getTopRatedMovies) : super(TopRatedMovieInitial());

  List<Movie> _topRated = <Movie>[];
  List<Movie> get topRated => _topRated;

  @override
  Stream<TopRatedMovieState> mapEventToState(
    TopRatedMovieEvent event,
  ) async* {
    if (event is LoadTopRatedMovie) {
      yield TopRatedMovieLoading();
      final getTopRatedTv = await _getTopRatedMovies.execute();
      yield* getTopRatedTv.fold(
        (failure) async* {
          yield TopRatedMovieError(failure.message);
        },
        (data) async* {
          _topRated = data;
          yield TopRatedMovieLoaded();
        },
      );
    }
  }
}
