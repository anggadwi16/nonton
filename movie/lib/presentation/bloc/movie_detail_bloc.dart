import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/movie.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieDetailBloc(
    this._getMovieDetail,
    this._getMovieRecommendations,
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(MovieDetailInitial());

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  List<Movie> _recommendation = [];
  List<Movie> get recommendation => _recommendation;

  bool _isAddedWatchlist = false;
  bool get isAddedWatchlist => _isAddedWatchlist;

  @override
  Stream<MovieDetailState> mapEventToState(
    MovieDetailEvent event,
  ) async* {
    if (event is LoadDetailMovie) {
      final id = event.id;
      yield MovieDetailLoading();
      final getDetail = await _getMovieDetail.execute(id);
      final getRecommendation = await _getMovieRecommendations.execute(id);
      final getWatchlistStatus = await _getWatchListStatus.execute(id);
      yield* getDetail.fold(
        (failure) async* {
          yield MovieDetailError(failure.message);
        },
        (detail) async* {
          _movie = detail;
          yield* getRecommendation.fold(
            (failure) async* {
              yield MovieDetailError(failure.message);
            },
            (recommendationData) async* {
              _recommendation = recommendationData;
              _isAddedWatchlist = getWatchlistStatus;
              yield MovieDetailLoaded();
            },
          );
        },
      );
    }

    if (event is AddWatchlistMovie) {
      yield MovieDetailWatchlist();
      final movie = event.movie;
      final result = await _saveWatchlist.execute(movie);
      yield* result.fold(
        (failure) async* {
          yield MovieDetailWatchlistMessage(failure.message);
        },
        (successMessage) async* {
          final getWatchlistStatus =
              await _getWatchListStatus.execute(movie.id);
          _isAddedWatchlist = getWatchlistStatus;
          yield MovieDetailWatchlistMessage(successMessage);
        },
      );
    }

    if (event is DeleteWatchlistMovie) {
      yield MovieDetailWatchlist();
      final movie = event.movie;
      final result = await _removeWatchlist.execute(movie);
      yield* result.fold(
        (failure) async* {
          yield MovieDetailWatchlistMessage(failure.message);
        },
        (successMessage) async* {
          final getWatchlistStatus =
              await _getWatchListStatus.execute(movie.id);
          _isAddedWatchlist = getWatchlistStatus;
          yield MovieDetailWatchlistMessage(successMessage);
        },
      );
    }
  }
}
