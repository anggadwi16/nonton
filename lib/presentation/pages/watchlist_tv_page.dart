import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/empty_data.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> {
  @override
  void initState() {
    context.read<WatchlistTvBloc>().add(LoadWatchlistTv());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
          builder: (context, state) {
            if (state is WatchlistTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvLoaded) {
              return context.read<WatchlistTvBloc>().watchlistTv.isEmpty
                  ? EmptyData('Data tidak ditemukan')
                  : ListView.builder(
                      itemCount:
                          context.read<WatchlistTvBloc>().watchlistTv.length,
                      itemBuilder: (context, index) {
                        final tv =
                            context.read<WatchlistTvBloc>().watchlistTv[index];
                        return InkWell(
                            onTap: () async {
                              dynamic result = await Navigator.pushNamed(
                                  context, TvSeriesDetailPage.ROUTE_NAME,
                                  arguments: tv.id);
                              if (result == null) {
                                context
                                    .read<WatchlistTvBloc>()
                                    .add(LoadWatchlistTv());
                              }
                            },
                            child: TvCard(tv));
                      },
                    );
            } else if (state is WatchlistTvError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
