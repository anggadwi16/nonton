import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTv _searchTv;
  SearchTvBloc(this._searchTv) : super(SearchTvInitial());

  List<Tv> _searchList = [];
  List<Tv> get searchList => _searchList;

  @override
  Stream<SearchTvState> mapEventToState(
    SearchTvEvent event,
  ) async* {
    if (event is OnChangeSearch) {
      yield SearchTvLoading();
      final query = event.query;
      final searchTv = await _searchTv.execute(query);
      yield* searchTv.fold(
        (failure) async* {
          yield SearchTvError(failure.message);
        },
        (data) async* {
          _searchList = data;
          yield SearchTvLoaded();
        },
      );
    }
  }
}
