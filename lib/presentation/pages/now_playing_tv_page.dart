import 'package:ditonton/presentation/bloc/now_playing_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv';
  @override
  _NowPlayingTvPageState createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    context.read<NowPlayingTvBloc>().add(LoadNowPlayingTv());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(
          builder: (context, state) {
            if (state is NowPlayingTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (state is NowPlayingTvError){
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
            else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = context.read<NowPlayingTvBloc>().nowPlaying[index];
                  return TvCard(tv);
                },
                itemCount: context.read<NowPlayingTvBloc>().nowPlaying.length,
              );
            }
          },
        ),
      ),
    );
  }
}
