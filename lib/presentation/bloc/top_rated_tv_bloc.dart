import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvInitial());

  late List<Tv> _topRated;
  List<Tv> get topRated => _topRated;

  @override
  Stream<TopRatedTvState> mapEventToState(
    TopRatedTvEvent event,
  ) async* {
    if (event is LoadTopRatedTv) {
      yield TopRatedTvLoading();
      final getTopRatedTv = await _getTopRatedTv.execute();
      yield* getTopRatedTv.fold(
        (failure) async* {
          yield TopRatedTvError(failure.message);
        },
        (topRatedData) async* {
          _topRated = topRatedData;
          yield TopRatedTvLoaded();
        },
      );
    }
  }
}
