import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])

void main(){
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp((){
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
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

  group('search tv', () {
    test('should change state to loading when usecase is called', () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      provider.fetchTvSearch(tQuery);
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully', () async {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      await provider.fetchTvSearch(tQuery);
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchTvSearch(tQuery);
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}