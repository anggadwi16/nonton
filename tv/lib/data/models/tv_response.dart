import 'package:equatable/equatable.dart';
import 'package:tv/tv.dart';

class TvResponse extends Equatable {
  final List<TvModel> tvList;

  TvResponse({required this.tvList});

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        tvList: List<TvModel>.from((json['results'] as List)
            .map((x) => TvModel.fromJson(x))
            .where((element) => element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        'results': List<dynamic>.from(tvList.map((e) => e.toJson())),
      };

  @override
  List<Object?> get props => [tvList];
}
