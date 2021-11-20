import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/tv_detail_notifier_test.mocks.dart';

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
    when(mockGetWatchlistTvStatus.execute(tId))
        .thenAnswer((_) async => true);
  }

  group('Get detail Tv', () {
    blocTest<TvDetailBloc, TvDetailState>("should get data from the usecase",
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
        });
  });
}
