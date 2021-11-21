part of 'search_tv_bloc.dart';

@immutable
abstract class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object> get props => [];
}

class SearchTvInitial extends SearchTvState {}

class SearchTvLoading extends SearchTvState {}

class SearchTvLoaded extends SearchTvState {}

class SearchTvError extends SearchTvState {
  final String message;
  SearchTvError(this.message);

  @override
  List<Object> get props => [message];
}
