part of 'now_playing_tv_bloc.dart';

@immutable
abstract class NowPlayingTvEvent extends Equatable {
  const NowPlayingTvEvent();

  @override
  List<Object> get props => [];
}

class LoadNowPlayingTv extends NowPlayingTvEvent {}
