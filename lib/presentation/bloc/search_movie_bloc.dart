import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies _searchMovies;
  SearchMovieBloc(this._searchMovies) : super(SearchMovieInitial());

  List<Movie> _searchList = [];
  List<Movie> get searchList => _searchList;

  @override
  Stream<SearchMovieState> mapEventToState(
    SearchMovieEvent event,
  ) async* {
    if (event is OnChangeSearchMovie) {
      yield SearchMovieLoading();
      final query = event.query;
      final searchMovie = await _searchMovies.execute(query);
      yield* searchMovie.fold(
        (failure) async* {
          yield SearchMovieError(failure.message);
        },
        (data) async* {
          _searchList = data;
          yield SearchMovieLoaded();
        },
      );
    }
  }
}
