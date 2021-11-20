part of 'tv_detail_bloc.dart';

@immutable
abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;
  TvDetailError(this.message);

  @override
  List<Object> get props => [];
}

class TvDetailLoaded extends TvDetailState {}

class TvDetailWatchlistMessage extends TvDetailState {
  final String message;
  TvDetailWatchlistMessage(this.message);

  @override
  List<Object> get props => [];
}

class TvDetailWatchlist extends TvDetailState {}
