import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(PopularTvInitial());

  late List<Tv> _popular;
  List<Tv> get popular => _popular;

  @override
  Stream<PopularTvState> mapEventToState(
    PopularTvEvent event,
  ) async* {
    if (event is LoadPopularTv) {
      yield PopularTvLoading();
      final getPopularTv = await _getPopularTv.execute();
      yield* getPopularTv.fold(
        (failure) async* {
          yield PopularTvError(failure.message);
        },
        (popularData) async* {
          _popular = popularData;
          yield PopularTvLoaded();
        },
      );
    }
  }
}
