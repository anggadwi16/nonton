import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])

void main(){
  late WatchlistTvNotifier provider;
  late MockGetWatchlistTv mockGetWatchlistTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTv = MockGetWatchlistTv();
    provider = WatchlistTvNotifier(mockGetWatchlistTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change tv data when data is gotten successfully', () async {
    when(mockGetWatchlistTv.execute())
        .thenAnswer((_) async => Right([testWatchlistTv]));
    await provider.fetchWatchlistTv();
    expect(provider.watchlistState, RequestState.loaded);
    expect(provider.watchlistTv, [testWatchlistTv]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetWatchlistTv.execute())
        .thenAnswer((_) async => Left(DatabaseFailure('Cannot get data')));
    await provider.fetchWatchlistTv();
    expect(provider.watchlistState, RequestState.error);
    expect(provider.message, 'Cannot get data');
    expect(listenerCallCount, 2);
  });
}