import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv/tv.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';
  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    context.read<PopularTvBloc>().add(LoadPopularTv());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context, state) {
            if (state is PopularTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else if (state is PopularTvLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = context.read<PopularTvBloc>().popular[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, TvSeriesDetailPage.ROUTE_NAME,
                          arguments: tv.id);
                    },
                    child: TvCard(tv),
                  );
                },
                itemCount: context.read<PopularTvBloc>().popular.length,
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
