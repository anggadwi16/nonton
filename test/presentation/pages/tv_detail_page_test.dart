import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockBloc extends Mock implements TvDetailBloc {}

class TvDetailEventFake extends Fake implements TvDetailEvent {}

class TvDetailStateFake extends Fake implements TvDetailState {}

void main() {
  late TvDetailBloc tvDetailBloc;

  setUpAll(() {
    registerFallbackValue(TvDetailEventFake());
    registerFallbackValue(TvDetailStateFake());
  });

  setUp(() {
    tvDetailBloc = MockBloc();
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

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: tvDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoading()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoading());
    when(() => tvDetailBloc.tv).thenAnswer((_) => testTvDetail);
    when(() => tvDetailBloc.tv).thenReturn(testTvDetail);
    when(() => tvDetailBloc.recommendation).thenAnswer((_) => tTvList);
    when(() => tvDetailBloc.recommendation).thenReturn(tTvList);
    when(() => tvDetailBloc.isAddedWatchlist).thenAnswer((_) => false);
    when(() => tvDetailBloc.isAddedWatchlist).thenReturn(false);
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoaded()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded());

    await tester.pumpWidget(
        _makeTestableWidget(TvSeriesDetailPage(id: testTvDetail.id)));
    final watchlistButtonIcon = find.byIcon(Icons.add);
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoading()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoading());
    when(() => tvDetailBloc.tv).thenAnswer((_) => testTvDetail);
    when(() => tvDetailBloc.tv).thenReturn(testTvDetail);
    when(() => tvDetailBloc.recommendation).thenAnswer((_) => tTvList);
    when(() => tvDetailBloc.recommendation).thenReturn(tTvList);
    when(() => tvDetailBloc.isAddedWatchlist).thenAnswer((_) => true);
    when(() => tvDetailBloc.isAddedWatchlist).thenReturn(true);
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoaded()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded());

    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(watchlistButtonIcon, findsOneWidget);
  });
  //
  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoading()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoading());
    when(() => tvDetailBloc.tv).thenAnswer((_) => testTvDetail);
    when(() => tvDetailBloc.tv).thenReturn(testTvDetail);
    when(() => tvDetailBloc.recommendation).thenAnswer((_) => tTvList);
    when(() => tvDetailBloc.recommendation).thenReturn(tTvList);
    when(() => tvDetailBloc.isAddedWatchlist).thenAnswer((_) => false);
    when(() => tvDetailBloc.isAddedWatchlist).thenReturn(false);
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoaded()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded());
    whenListen(
        tvDetailBloc,
        Stream.fromIterable([
          TvDetailWatchlist(),
          TvDetailWatchlistMessage('Added to Watchlist'),
        ]));

    final watchlistButton = find.byType(ElevatedButton);
    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(watchlistButton);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
  //
  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoading()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoading());
    when(() => tvDetailBloc.tv).thenAnswer((_) => testTvDetail);
    when(() => tvDetailBloc.tv).thenReturn(testTvDetail);
    when(() => tvDetailBloc.recommendation).thenAnswer((_) => tTvList);
    when(() => tvDetailBloc.recommendation).thenReturn(tTvList);
    when(() => tvDetailBloc.isAddedWatchlist).thenAnswer((_) => false);
    when(() => tvDetailBloc.isAddedWatchlist).thenReturn(false);
    when(() => tvDetailBloc.stream)
        .thenAnswer((_) => Stream.value(TvDetailLoaded()));
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded());
    whenListen(
        tvDetailBloc,
        Stream.fromIterable([
          TvDetailWatchlist(),
          TvDetailWatchlistMessage('Failed'),
        ]));

    final watchlistButton = find.byType(ElevatedButton);
    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
