part of 'movie_detail_bloc.dart';

@immutable
abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetailMovie extends MovieDetailEvent {
  final int id;
  LoadDetailMovie(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistMovie extends MovieDetailEvent {
  final MovieDetail movie;
  AddWatchlistMovie(this.movie);

  @override
  List<Object> get props => [movie];
}

class DeleteWatchlistMovie extends MovieDetailEvent {
  final MovieDetail movie;
  DeleteWatchlistMovie(this.movie);

  @override
  List<Object> get props => [movie];
}
