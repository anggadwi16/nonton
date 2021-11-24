import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockBloc extends Mock implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

void main() {
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    movieDetailBloc = MockBloc();
  });

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: movieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoading()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => movieDetailBloc.movie).thenAnswer((_) => testMovieDetail);
    when(() => movieDetailBloc.movie).thenReturn(testMovieDetail);
    when(() => movieDetailBloc.recommendation).thenAnswer((_) => tMovieList);
    when(() => movieDetailBloc.recommendation).thenReturn(tMovieList);
    when(() => movieDetailBloc.isAddedWatchlist).thenAnswer((_) => false);
    when(() => movieDetailBloc.isAddedWatchlist).thenReturn(false);
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoaded()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoaded());

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoading()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => movieDetailBloc.movie).thenAnswer((_) => testMovieDetail);
    when(() => movieDetailBloc.movie).thenReturn(testMovieDetail);
    when(() => movieDetailBloc.recommendation).thenAnswer((_) => tMovieList);
    when(() => movieDetailBloc.recommendation).thenReturn(tMovieList);
    when(() => movieDetailBloc.isAddedWatchlist).thenAnswer((_) => true);
    when(() => movieDetailBloc.isAddedWatchlist).thenReturn(true);
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoaded()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoaded());

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoading()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => movieDetailBloc.movie).thenAnswer((_) => testMovieDetail);
    when(() => movieDetailBloc.movie).thenReturn(testMovieDetail);
    when(() => movieDetailBloc.recommendation).thenAnswer((_) => tMovieList);
    when(() => movieDetailBloc.recommendation).thenReturn(tMovieList);
    when(() => movieDetailBloc.isAddedWatchlist).thenAnswer((_) => false);
    when(() => movieDetailBloc.isAddedWatchlist).thenReturn(false);
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoaded()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoaded());
    whenListen(
        movieDetailBloc,
        Stream.fromIterable([
          MovieDetailWatchlist(),
          MovieDetailWatchlistMessage('Added to Watchlist'),
        ]));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoading()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => movieDetailBloc.movie).thenAnswer((_) => testMovieDetail);
    when(() => movieDetailBloc.movie).thenReturn(testMovieDetail);
    when(() => movieDetailBloc.recommendation).thenAnswer((_) => tMovieList);
    when(() => movieDetailBloc.recommendation).thenReturn(tMovieList);
    when(() => movieDetailBloc.isAddedWatchlist).thenAnswer((_) => false);
    when(() => movieDetailBloc.isAddedWatchlist).thenReturn(false);
    when(() => movieDetailBloc.stream)
        .thenAnswer((_) => Stream.value(MovieDetailLoaded()));
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoaded());
    whenListen(
        movieDetailBloc,
        Stream.fromIterable([
          MovieDetailWatchlist(),
          MovieDetailWatchlistMessage('Failed'),
        ]));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
