part of 'movie_detail_bloc.dart';

@immutable
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}
class MovieDetailLoaded extends MovieDetailState {}
class MovieDetailError extends MovieDetailState {
  final String message;
  MovieDetailError(this.message);

  @override
  List<Object> get props => [];
}

class MovieDetailWatchlistMessage extends MovieDetailState {
  final String message;
  MovieDetailWatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailWatchlist extends MovieDetailState {}
