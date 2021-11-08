import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

main(){
  final tTvModel = TvModel(
      backdropPath: "/path.jpg",
      genreIds: [1,2,3,4],
      id: 1,
      originalName: "original_name",
      overview: "Overview",
      popularity: 1.0,
      posterPath: "/path.jpg",
      name: "Name",
      voteAverage: 3.2,
      voteCount: 3,
  );

  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);

  group('fromJson', (){
    test('should return a valid model from JSON', () async{
      final Map<String, dynamic> jsonMap = json.decode(readJson('dummy_data/tv_airing_today.json'));
      final result = TvResponse.fromJson(jsonMap);
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', (){
    test('should return a JSON map containing proper data', () async{
      final result = tTvResponseModel.toJson();
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "genre_ids": [
              1,
              2,
              3,
              4
            ],
            "id": 1,
            "name": "Name",
            "original_name": "original_name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "vote_average": 3.2,
            "vote_count": 3
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}