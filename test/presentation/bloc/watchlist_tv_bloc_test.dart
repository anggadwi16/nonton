import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late WatchlistTvBloc watchlistTvBloc;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    watchlistTvBloc = WatchlistTvBloc(mockGetWatchlistTv);
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

  group('Watchlist Tv', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Loaded] when get watchlist tv successful',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTv()),
      expect: () => <WatchlistTvState>[
        WatchlistTvLoading(),
        WatchlistTvLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
      },
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Error] when get watchlist tv unsuccessful',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('DB Failure')));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistTv()),
      expect: () => <WatchlistTvState>[
        WatchlistTvLoading(),
        WatchlistTvError('DB Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
      },
    );
  });
}
