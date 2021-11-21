part of 'top_rated_tv_bloc.dart';

@immutable
abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object> get props => [];
}

class TopRatedTvInitial extends TopRatedTvState {}

class TopRatedTvLoading extends TopRatedTvState {}

class TopRatedTvLoaded extends TopRatedTvState {}

class TopRatedTvError extends TopRatedTvState {
  final String message;
  TopRatedTvError(this.message);

  @override
  List<Object> get props => [];
}
