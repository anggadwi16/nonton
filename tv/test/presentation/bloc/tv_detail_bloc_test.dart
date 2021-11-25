import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchlistTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvDetailBloc = TvDetailBloc(mockGetTvDetail, mockGetTvRecommendations,
        mockGetWatchlistTvStatus, mockSaveWatchlistTv, mockRemoveWatchlistTv);
  });

  final tId = 1;

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

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvList));
    when(mockGetWatchlistTvStatus.execute(tId)).thenAnswer((_) async => true);
  }

  group('Get detail Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      "Should emit [Loading, Loaded] when get detail tv successful",
      build: () {
        _arrangeUsecase();
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(LoadDetail(tId)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TvDetailLoading(),
        TvDetailLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        verify(mockGetWatchlistTvStatus.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      "Should emit [Loading, Error] when get detail tv unsuccessful",
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchlistTvStatus.execute(tId))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(LoadDetail(tId)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TvDetailLoading(),
        TvDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        verify(mockGetWatchlistTvStatus.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should Add Watchlist is success',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Right('Success'));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvDetail)),
      expect: () => <TvDetailState>[
        TvDetailWatchlist(),
        TvDetailWatchlistMessage('Success'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchlistTvStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should Remove Watchlist is success',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Right('Success'));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(DeleteWatchlistTv(testTvDetail)),
      expect: () => <TvDetailState>[
        TvDetailWatchlist(),
        TvDetailWatchlistMessage('Success'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchlistTvStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should Add Watchlist is unsuccess',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failure')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvDetail)),
      expect: () => <TvDetailState>[
        TvDetailWatchlist(),
        TvDetailWatchlistMessage('Failure'),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should Remove Watchlist is unsuccess',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failure')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(DeleteWatchlistTv(testTvDetail)),
      expect: () => <TvDetailState>[
        TvDetailWatchlist(),
        TvDetailWatchlistMessage('Failure'),
      ],
    );
  });
}
