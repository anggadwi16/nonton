part of 'popular_tv_bloc.dart';

@immutable
abstract class PopularTvState extends Equatable {
  const PopularTvState();
  @override
  List<Object> get props => [];
}

class PopularTvInitial extends PopularTvState {}

class PopularTvLoading extends PopularTvState {}

class PopularTvLoaded extends PopularTvState {}

class PopularTvError extends PopularTvState {
  final String message;
  PopularTvError(this.message);

  @override
  List<Object> get props => [];
}
