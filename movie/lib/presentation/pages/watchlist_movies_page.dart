
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistMovieBloc>().add(LoadWatchlistMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
          builder: (context, state) {
            if (state is WatchlistMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistMovieLoaded) {
              final data = context.read<WatchlistMovieBloc>().watchlistMovie;
              return data.isEmpty
                  ? EmptyData('Data tidak ditemukan')
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = data[index];
                        return InkWell(
                            onTap: () async {
                              dynamic result = await Navigator.pushNamed(
                                context,
                                MovieDetailPage.ROUTE_NAME,
                                arguments: movie.id,
                              );
                              if (result == null) {
                                context
                                    .read<WatchlistMovieBloc>()
                                    .add(LoadWatchlistMovie());
                              }
                            },
                            child: MovieCard(movie));
                      },
                      itemCount: data.length,
                    );
            } else if (state is WatchlistMovieError) {
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
