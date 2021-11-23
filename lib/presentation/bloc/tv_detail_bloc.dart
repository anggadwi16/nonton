import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail _getTvDetail;
  final GetTvRecommendations _getTvRecommendations;
  final GetWatchlistTvStatus _getWatchlistTvStatus;
  final SaveWatchlistTv _saveWatchlistTv;
  final RemoveWatchlistTv _removeWatchlistTv;

  TvDetailBloc(
    this._getTvDetail,
    this._getTvRecommendations,
    this._getWatchlistTvStatus,
    this._saveWatchlistTv,
    this._removeWatchlistTv,
  ) : super(TvDetailLoading());

  late TvDetail _tv;
  TvDetail get tv => _tv;

  List<Tv> _recommendation = [];
  List<Tv> get recommendation => _recommendation;

  bool _isAddedWatchlist = false;
  bool get isAddedWatchlist => _isAddedWatchlist;

  @override
  Stream<TvDetailState> mapEventToState(
    TvDetailEvent event,
  ) async* {
    if (event is LoadDetail) {
      final id = event.id;
      yield TvDetailLoading();
      final getDetail = await _getTvDetail.execute(id);
      final getRecommendation = await _getTvRecommendations.execute(id);
      final getWatchlistStatus = await _getWatchlistTvStatus.execute(id);
      yield* getDetail.fold(
        (failure) async* {
          yield TvDetailError(failure.message);
        },
        (tvDetail) async* {
          _tv = tvDetail;
          yield* getRecommendation.fold(
            (failure) async* {
              yield TvDetailError(failure.message);
            },
            (recommendationData) async* {
              _recommendation = recommendationData;
              _isAddedWatchlist = getWatchlistStatus;
              yield TvDetailLoaded();
            },
          );
        },
      );
    }

    if (event is AddWatchlistTv) {
      yield TvDetailWatchlist();
      final tv = event.tv;
      final result = await _saveWatchlistTv.execute(tv);
      yield* result.fold((failure) async* {
        yield TvDetailWatchlistMessage(failure.message);
      }, (successMessage) async* {
        final getWatchlistStatus = await _getWatchlistTvStatus.execute(tv.id);
        _isAddedWatchlist = getWatchlistStatus;
        yield TvDetailWatchlistMessage(successMessage);
      });
    }

    if (event is DeleteWatchlistTv) {
      yield TvDetailWatchlist();
      final tv = event.tv;
      final result = await _removeWatchlistTv.execute(tv);
      yield* result.fold(
        (failure) async* {
          yield TvDetailWatchlistMessage(failure.message);
        },
        (successMessage) async* {
          final getWatchlistStatus = await _getWatchlistTvStatus.execute(tv.id);
          _isAddedWatchlist = getWatchlistStatus;
          yield TvDetailWatchlistMessage(successMessage);
        },
      );
    }
  }
}
