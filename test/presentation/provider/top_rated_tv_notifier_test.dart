import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])

void main() {
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TopRatedTvNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTv = MockGetTopRatedTv();
    notifier = TopRatedTvNotifier(mockGetTopRatedTv)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTv = Tv(
      backdropPath: "backdropPath",
      genreIds: [1,2,3],
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

  test('should change state to loading when usecase is called', () {
    when(mockGetTopRatedTv.execute())
        .thenAnswer((_) async => Right(tTvList));
    notifier.fetchTopRatedTv();
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    when(mockGetTopRatedTv.execute())
        .thenAnswer((_) async => Right(tTvList));
    await notifier.fetchTopRatedTv();
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should error when data is unsuccessful', () async {
    when(mockGetTopRatedTv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    await notifier.fetchTopRatedTv();
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}