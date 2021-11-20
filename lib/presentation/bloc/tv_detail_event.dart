part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetail extends TvDetailEvent {
  final int id;
  LoadDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistTv extends TvDetailEvent {
  final TvDetail tv;
  AddWatchlistTv(this.tv);

  @override
  List<Object> get props => [tv];
}

class DeleteWatchlistTv extends TvDetailEvent {
  final TvDetail tv;
  DeleteWatchlistTv(this.tv);

  @override
  List<Object> get props => [tv];
}

class WatchlistTvStatus extends TvDetailEvent {
  final int id;
  WatchlistTvStatus(this.id);
}
