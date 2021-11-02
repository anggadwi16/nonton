import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv';
  @override
  _NowPlayingTvPageState createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<NowPlayingTvNotifier>(context, listen: false)
          .fetchNowPlayingTv());
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
        child: Consumer<NowPlayingTvNotifier>(
          builder: (context, data, child){
            if(data.state == RequestState.Loading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if (data.state == RequestState.Loaded){
              return ListView.builder(
                itemBuilder: (context, index){
                  final tv = data.tv[index];
                  return TvCard(tv);
                },
                itemCount: data.tv.length,
              );
            }else{
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
