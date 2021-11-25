import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv/tv.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;
  WatchlistTvBloc(this._getWatchlistTv) : super(WatchlistTvInitial());

  List<Tv> _watchlistTv = [];
  List<Tv> get watchlistTv => _watchlistTv;

  @override
  Stream<WatchlistTvState> mapEventToState(
    WatchlistTvEvent event,
  ) async* {
    if (event is LoadWatchlistTv) {
      yield WatchlistTvLoading();
      final getWatchlistTv = await _getWatchlistTv.execute();
      yield* getWatchlistTv.fold(
        (failure) async* {
          yield WatchlistTvError(failure.message);
        },
        (data) async* {
          _watchlistTv = data;
          yield WatchlistTvLoaded();
        },
      );
    }
  }
}
