import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/widgets/movie_drawer.dart';
import 'package:flutter/material.dart';

class TVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "tv-series";
  @override
  _TVSeriesPageState createState() => _TVSeriesPageState();
}

class _TVSeriesPageState extends State<TVSeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Series'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){

              },
          ),
        ],
      ),
      drawer: MovieDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6,),
            ],
          ),
        ),
      ),
    );
  }
}
