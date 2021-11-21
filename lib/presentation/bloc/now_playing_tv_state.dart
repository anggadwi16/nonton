part of 'now_playing_tv_bloc.dart';

@immutable
abstract class NowPlayingTvState extends Equatable {
  const NowPlayingTvState();
  @override
  List<Object> get props => [];
}

class NowPlayingTvInitial extends NowPlayingTvState {}

class NowPlayingTvLoading extends NowPlayingTvState {}

class NowPlayingTvLoaded extends NowPlayingTvState {}

class NowPlayingTvError extends NowPlayingTvState {
  final String message;
  NowPlayingTvError(this.message);

  @override
  List<Object> get props => [];
}
