part of 'tv_list_bloc.dart';

@immutable
abstract class TvListState extends Equatable {
  const TvListState();

  @override
  List<Object> get props => [];
}

class TvListInitial extends TvListState {}

class TvListLoading extends TvListState {}

class TvListLoaded extends TvListState {}

class TvListError extends TvListState {
  final String message;
  TvListError(this.message);

  @override
  List<Object> get props => [message];
}
