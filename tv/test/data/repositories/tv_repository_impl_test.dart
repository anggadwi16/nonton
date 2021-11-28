import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModel = TvModel(
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

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('Now Playing TV', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTv())
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getNowPlayingTv();
      verify(mockRemoteDataSource.getNowPlayingTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTv()).thenThrow(ServerException());
      final result = await repository.getNowPlayingTv();
      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connection to internet',
        () async {
      when(mockRemoteDataSource.getNowPlayingTv())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getNowPlayingTv();
      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return ssl connection failure get now playing tv', () async {
      when(mockRemoteDataSource.getNowPlayingTv()).thenThrow(TlsException());
      final result = await repository.getNowPlayingTv();
      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result, equals(Left(CommonFailure('Certificated not valid'))));
    });
  });

  group('Popular TV', () {
    test('should return movie list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getPopularTv();
      verify(mockRemoteDataSource.getPopularTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'shpuld return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getPopularTv()).thenThrow(ServerException());
      final result = await repository.getPopularTv();
      verify(mockRemoteDataSource.getPopularTv());
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getPopularTv();
      verify(mockRemoteDataSource.getPopularTv());
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });

    test('should return ssl connection failure get popular tv', () async {
      when(mockRemoteDataSource.getPopularTv()).thenThrow(TlsException());
      final result = await repository.getPopularTv();
      verify(mockRemoteDataSource.getPopularTv());
      expect(result, equals(Left(CommonFailure('Certificated not valid'))));
    });
  });

  group('Top Rated Tv', () {
    test('should return tv list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getTopRatedTv();
      verify(mockRemoteDataSource.getTopRatedTv());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return Server Failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTopRatedTv()).thenThrow(ServerException());
      final result = await repository.getTopRatedTv();
      verify(mockRemoteDataSource.getTopRatedTv());
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return Connection Failure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTopRatedTv())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTopRatedTv();
      verify(mockRemoteDataSource.getTopRatedTv());
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });

    test('should return ssl connection failure get top rated tv', () async {
      when(mockRemoteDataSource.getTopRatedTv()).thenThrow(TlsException());
      final result = await repository.getTopRatedTv();
      verify(mockRemoteDataSource.getTopRatedTv());
      expect(result, equals(Left(CommonFailure('Certificated not valid'))));
    });
  });

  group('Get TV Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
      backdropPath: "backdropPath",
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "homepage",
      id: 1,
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1.0,
      posterPath: "posterPath",
      status: "status",
      tagline: "tagline",
      name: "name",
      voteAverage: 1.0,
      voteCount: 1,
      seasons: [
        SeasonModel(
          airDate: "airDate",
          episodeCount: 1,
          id: 1,
          name: "name",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1,
        )
      ],
    );

    test(
        'should return tv data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      final result = await repository.getDetailTv(tId);
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(ServerException());
      final result = await repository.getDetailTv(tId);
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getDetailTv(tId);
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return ssl connection failure get detail tv', () async {
      when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(TlsException());
      final result = await repository.getDetailTv(tId);
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(CommonFailure('Certificated not valid'))));
    });
  });

  group('Get TV Recommendations', () {
    final tTvList = <TvModel>[];
    final tId = 1;

    test('should return data tv list when the call is successful', () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvList);
      final result = await repository.getRecommendationTv(tId);
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getRecommendationTv(tId);
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getRecommendationTv(tId);
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return ssl connection failure get recommendation tv', () async {
      when(mockRemoteDataSource.getTvRecommendations(tId)).thenThrow(TlsException());
      final result = await repository.getRecommendationTv(tId);
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(Left(CommonFailure('Certificated not valid'))));
    });
  });

  group('Search Tv', () {
    final tQuery = 'squid';

    test('should return tv list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.searchTv(tQuery);
      verify(mockRemoteDataSource.searchTv(tQuery));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return Server Failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.searchTv(tQuery)).thenThrow(ServerException());
      final result = await repository.searchTv(tQuery);
      verify(mockRemoteDataSource.searchTv(tQuery));
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return Connection Failure when device is not connect to the internet',
        () async {
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.searchTv(tQuery);
      verify(mockRemoteDataSource.searchTv(tQuery));
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });

    test('should return ssl connection failure get search tv', () async {
      when(mockRemoteDataSource.searchTv(tQuery)).thenThrow(TlsException());
      final result = await repository.searchTv(tQuery);
      verify(mockRemoteDataSource.searchTv(tQuery));
      expect(result, equals(Left(CommonFailure('Certificated not valid'))));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlistTv(testTvDetail);
      expect(result, Right('Added to Watchlist'));
    });

    test('should return Database Failure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlistTv(testTvDetail);
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successfull', () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      final result = await repository.removeWatchlistTv(testTvDetail);
      expect(result, Right('Removed from watchlist'));
    });

    test('should return Database Failure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlistTv(testTvDetail);
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlistTv(tId);
      expect(result, false);
    });
  });

  group('get watchlist tv', () {
    test('should return list of tv', () async {
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      final result = await repository.getWatchlistTv();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
