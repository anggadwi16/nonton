import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv/tv.dart';

part 'now_playing_tv_event.dart';
part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTv _getNowPlayingTv;

  NowPlayingTvBloc(this._getNowPlayingTv) : super(NowPlayingTvInitial());

  late List<Tv> _nowPlaying;
  List<Tv> get nowPlaying => _nowPlaying;

  @override
  Stream<NowPlayingTvState> mapEventToState(
    NowPlayingTvEvent event,
  ) async* {
    if (event is LoadNowPlayingTv) {
      yield NowPlayingTvLoading();
      final getNowPlayingTv = await _getNowPlayingTv.execute();
      yield* getNowPlayingTv.fold(
        (failure) async* {
          yield NowPlayingTvError(failure.message);
        },
        (tvData) async* {
          _nowPlaying = tvData;
          yield NowPlayingTvLoaded();
        },
      );
    }
  }
}
