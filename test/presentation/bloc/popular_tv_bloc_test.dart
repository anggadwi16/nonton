import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvBloc popularTvBloc;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  final tTv = Tv(
    backdropPath: "backdropPath",
    genreIds: [1, 2, 3],
    id: 1,
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    name: "name",
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvList = <Tv>[tTv];

  group('Popular Tv', () {
    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Loaded] when get popular tv successful',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(LoadPopularTv()),
      expect: () => <PopularTvState>[
        PopularTvLoading(),
        PopularTvLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Error] when get popular tv unsuccessful',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(LoadPopularTv()),
      expect: () => <PopularTvState>[
        PopularTvLoading(),
        PopularTvError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      },
    );
  });
}
