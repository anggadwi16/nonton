import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetPopularTv,
  GetNowPlayingTv,
  GetTopRatedTv,
])
void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TvListBloc tvListBloc;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    mockGetPopularTv = MockGetPopularTv();
    tvListBloc = TvListBloc(
      mockGetPopularTv,
      mockGetNowPlayingTv,
      mockGetTopRatedTv,
    );
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

  group('Tv List', () {
    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Loaded] when get tv list successful',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(LoadTvList()),
      expect: () => <TvListState>[
        TvListLoading(),
        TvListLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
        verify(mockGetPopularTv.execute());
        verify(mockGetNowPlayingTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Error] when get tv list unsuccessful',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(LoadTvList()),
      expect: () => <TvListState>[
        TvListLoading(),
        TvListError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
        verify(mockGetPopularTv.execute());
        verify(mockGetNowPlayingTv.execute());
      },
    );
  });
}
