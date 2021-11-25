import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';

import 'now_playing_tv_bloc_test.mocks.dart';


@GenerateMocks([GetNowPlayingTv])
void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late NowPlayingTvBloc nowPlayingTvBloc;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    nowPlayingTvBloc = NowPlayingTvBloc(mockGetNowPlayingTv);
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

  group(
    'Now Playing tv',
    () {
      blocTest<NowPlayingTvBloc, NowPlayingTvState>(
        'Should emit [Loading, Loaded] when get now playing tv successful',
        build: () {
          when(mockGetNowPlayingTv.execute())
              .thenAnswer((_) async => Right(tTvList));
          return nowPlayingTvBloc;
        },
        act: (bloc) => bloc.add(LoadNowPlayingTv()),
        expect: () => <NowPlayingTvState>[
          NowPlayingTvLoading(),
          NowPlayingTvLoaded(),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingTv.execute());
        },
      );

      blocTest<NowPlayingTvBloc, NowPlayingTvState>(
        'Should emit [Loading, Error] when get now playing tv unsuccessful',
        build: () {
          when(mockGetNowPlayingTv.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return nowPlayingTvBloc;
        },
        act: (bloc) => bloc.add(LoadNowPlayingTv()),
        expect: () => <NowPlayingTvState>[
          NowPlayingTvLoading(),
          NowPlayingTvError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingTv.execute());
        },
      );
    },
  );
}
