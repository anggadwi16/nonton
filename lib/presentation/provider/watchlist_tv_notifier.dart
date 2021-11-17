import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

class WatchlistTvNotifier extends ChangeNotifier {
  final GetWatchlistTv getWatchlistTv;
  var _watchlistTV = <Tv>[];
  List<Tv> get watchlistTv => _watchlistTV;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTvNotifier(this.getWatchlistTv);

  Future<void> fetchWatchlistTv() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlistTv.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _watchlistState = RequestState.loaded;
        _watchlistTV = tvData;
        notifyListeners();
      },
    );
  }
}
