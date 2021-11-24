import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloc extends Mock implements TopRatedTvBloc {}

class TopRatedTvEventFake extends Fake implements TopRatedTvEvent {}

class TopRatedTvStateFake extends Fake implements TopRatedTvState {}

void main(){
  late TopRatedTvBloc topRatedTvBloc;

  setUp((){
    topRatedTvBloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body){
    return BlocProvider<TopRatedTvBloc>.value(
      value: topRatedTvBloc,
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

  testWidgets('Page should display progress bar when loading', (WidgetTester tester) async{
    when(() => topRatedTvBloc.stream).thenAnswer((_) => Stream.value(TopRatedTvLoading()));
    when(() => topRatedTvBloc.state).thenReturn(TopRatedTvLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));
    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (WidgetTester tester) async{
    when(() => topRatedTvBloc.stream).thenAnswer((_) => Stream.value(TopRatedTvLoading()));
    when(() => topRatedTvBloc.state).thenReturn(TopRatedTvLoading());
    when(() => topRatedTvBloc.stream).thenAnswer((_) => Stream.value(TopRatedTvLoaded()));
    when(() => topRatedTvBloc.state).thenReturn(TopRatedTvLoaded());
    when(() => topRatedTvBloc.topRated).thenAnswer((_) => tTvList);
    when(() => topRatedTvBloc.topRated).thenReturn(tTvList);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (WidgetTester tester) async{
    when(() => topRatedTvBloc.stream).thenAnswer((_) => Stream.value(TopRatedTvError('Error')));
    when(() => topRatedTvBloc.state).thenReturn(TopRatedTvError('Error'));

    final textFinder = find.byKey(Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));
    expect(textFinder, findsOneWidget);
  });
}