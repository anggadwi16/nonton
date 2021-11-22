import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';
  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    context.read<TvDetailBloc>().add(LoadDetail(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TvDetailBloc, TvDetailState>(
        listener: (context, state) {
          if (state is TvDetailWatchlistMessage) {
            if (state.message == TvDetailBloc.watchlistAddSuccessMessage ||
                state.message == TvDetailBloc.watchlistRemoveSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(state.message),
                    );
                  });
            }
          }
        },
        child: BlocBuilder<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            if (state is TvDetailLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvDetailError) {
              return Center(child: Text(state.message));
            } else if (state is TvDetailLoaded) {
              return SafeArea(
                child: DetailContent(
                  context.read<TvDetailBloc>().tv,
                  context.read<TvDetailBloc>().recommendation,
                  context.read<TvDetailBloc>().isAddedWatchlist,
                ),
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

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;
  DetailContent(
    this.tv,
    this.recommendations,
    this.isAddedWatchlist,
  );
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvDetailBloc>()
                                      .add(AddWatchlistTv(tv));
                                } else {
                                  context
                                      .read<TvDetailBloc>()
                                      .add(DeleteWatchlistTv(tv));
                                }
                              },
                              child: BlocBuilder<TvDetailBloc, TvDetailState>(
                                  builder: (context, state) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                );
                              }),
                            ),
                            Text(_showGenres(tv.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                  itemCount: 5,
                                  rating: tv.voteAverage / 2,
                                ),
                                Text('${tv.voteAverage / 2}'),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(tv.overview),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Season',
                              style: kHeading6,
                            ),
                            Container(
                              height: 170,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: tv.seasons.length,
                                itemBuilder: (context, index) {
                                  Season season = tv.seasons[index];
                                  return Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              'https://image.tmdb.org/t/p/w500${season.posterPath}',
                                          height: 100,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.image_not_supported),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          season.name,
                                        ),
                                        Text(
                                            'Total Episode ${season.episodeCount}'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final tv = recommendations[index];
                                  return Padding(
                                    padding: EdgeInsets.all(4),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(context,
                                            TvSeriesDetailPage.ROUTE_NAME,
                                            arguments: tv.id);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            (Radius.circular(8))),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: recommendations.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    )
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }
    if (result.isEmpty) {
      return result;
    }
    return result.substring(0, result.length - 2);
  }
}
