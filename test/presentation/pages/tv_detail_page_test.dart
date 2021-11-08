import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])

void main(){
  late MockTvDetailNotifier mockTvDetailNotifier;

  setUp((){
    mockTvDetailNotifier = MockTvDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body){
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockTvDetailNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Watchlist button should display add icon when tv not added to watchlist', (WidgetTester tester) async{
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
    when(mockTvDetailNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockTvDetailNotifier.isAddedtoWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should display check icon when movie is added to watchlist', (WidgetTester tester) async{
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
    when(mockTvDetailNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockTvDetailNotifier.isAddedtoWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when added to watchlist', (WidgetTester tester) async{
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
    when(mockTvDetailNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockTvDetailNotifier.isAddedtoWatchlist).thenReturn(false);
    when(mockTvDetailNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);
    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(watchlistButton);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('Watchlist button should display AlertDialog when add to watchlist failed', (WidgetTester tester) async{
    when(mockTvDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tv).thenReturn(testTvDetail);
    when(mockTvDetailNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockTvDetailNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockTvDetailNotifier.isAddedtoWatchlist).thenReturn(false);
    when(mockTvDetailNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);
    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
