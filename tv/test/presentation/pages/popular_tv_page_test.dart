
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

class MockBloc extends Mock implements PopularTvBloc {}

class PopularTvEventFake extends Fake implements PopularTvEvent {}

class PopularTvStateFake extends Fake implements PopularTvState {}

void main() {
  late PopularTvBloc popularTvBloc;

  setUp(() {
    popularTvBloc = MockBloc();
  });

  setUpAll(() {
    registerFallbackValue(PopularTvEventFake());
    registerFallbackValue(PopularTvStateFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>.value(
      value: popularTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

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

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularTvBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvLoading()));
    when(() => popularTvBloc.state).thenReturn(PopularTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => popularTvBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvLoading()));
    when(() => popularTvBloc.state).thenReturn(PopularTvLoading());
    when(() => popularTvBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvLoaded()));
    when(() => popularTvBloc.state).thenReturn(PopularTvLoaded());
    when(() => popularTvBloc.popular).thenAnswer((_) => tTvList);
    when(() => popularTvBloc.popular).thenReturn(tTvList);

    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularTvBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvError('Error')));
    when(() => popularTvBloc.state).thenReturn(PopularTvError('Error'));

    final textFinder = find.byKey(Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));
    expect(textFinder, findsOneWidget);
  });
}
