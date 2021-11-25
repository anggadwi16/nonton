import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv/tv.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetPopularTv _getPopularTv;
  final GetNowPlayingTv _getNowPlayingTv;
  final GetTopRatedTv _getTopRatedTv;

  TvListBloc(
    this._getPopularTv,
    this._getNowPlayingTv,
    this._getTopRatedTv,
  ) : super(TvListInitial());

  List<Tv> _nowPlayingTv = [];
  List<Tv> _topRatedTv = [];
  List<Tv> _popularTv = [];

  List<Tv> get nowPlayingTv => _nowPlayingTv;
  List<Tv> get popularTv => _popularTv;
  List<Tv> get topRatedTv => _topRatedTv;

  @override
  Stream<TvListState> mapEventToState(
    TvListEvent event,
  ) async* {
    if (event is LoadTvList) {
      yield TvListLoading();
      final getNowPlayingTv = await _getNowPlayingTv.execute();
      final getPopularTv = await _getPopularTv.execute();
      final getTopRatedTv = await _getTopRatedTv.execute();

      yield* getNowPlayingTv.fold(
        (failure) async* {
          yield TvListError(failure.message);
        },
        (nowPlaying) async* {
          _nowPlayingTv = nowPlaying;
          yield* getPopularTv.fold(
            (failure) async* {
              yield TvListError(failure.message);
            },
            (popular) async* {
              _popularTv = popular;
              yield* getTopRatedTv.fold(
                (failure) async* {
                  yield TvListError(failure.message);
                },
                (topRated) async* {
                  _topRatedTv = topRated;
                  yield TvListLoaded();
                },
              );
            },
          );
        },
      );
    }
  }
}
