import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late MockSearchTv mockSearchTv;
  late SearchTvBloc searchTvBloc;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  final tTvModel = Tv(
    backdropPath: "backdropPath",
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'Squid Game',
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    name: 'Squid Game',
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTvList = <Tv>[tTvModel];
  final tQuery = 'squid';

  group('Search Tv', () {
    blocTest<SearchTvBloc, SearchTvState>(
      'Should emit [Loading, Loaded] when search tv successful',
      build: () {
        when(mockSearchTv.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return searchTvBloc;
      },
      act: (bloc) => bloc.add(OnChangeSearch(tQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => <SearchTvState>[
        SearchTvLoading(),
        SearchTvLoaded(),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(tQuery));
      },
    );

    blocTest<SearchTvBloc, SearchTvState>(
      'Should emit [Loading, Error] when search tv unsuccessful',
      build: () {
        when(mockSearchTv.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchTvBloc;
      },
      act: (bloc) => bloc.add(OnChangeSearch(tQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => <SearchTvState>[
        SearchTvLoading(),
        SearchTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(tQuery));
      },
    );
  });
}
