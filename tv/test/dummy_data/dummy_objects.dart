

import 'package:tv/tv.dart';

final testTv = Tv(
  backdropPath: "/75XgXxvZ7bYg6sRIBQKDdBlyTFY.jpg",
  genreIds: [18, 10766],
  id: 133372,
  originalName: 'मीत',
  overview:
      "A remake of Zee Sarthak’s Sindura Bindu.\n\nDespite her efforts to provide for her family, Meets disregard for societal gender norms and her nonconformist job as a delivery agent make her an unsuitable girl in the eyes of her family.",
  popularity: 1491.293,
  posterPath: "/9X7FovF5n8NQUHUPJYYfxRlF3yp.jpg",
  name: 'Meet',
  voteAverage: 3.2,
  voteCount: 3,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  backdropPath: "backdropPath",
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: "originalName",
  overview: "overview",
  posterPath: "posterPath",
  name: 'name',
  voteAverage: 1.0,
  voteCount: 1,
  seasons: [
    Season(
      airDate: "airDate",
      episodeCount: 1,
      id: 1,
      name: 'name',
      overview: "overview",
      posterPath: "posterPath",
      seasonNumber: 1,
    ),
  ],
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  overview: "overview",
  posterPath: "posterPath",
  name: "name",
);

final testTvTable = TvTable(
  id: 1,
  name: "name",
  posterPath: "posterPath",
  overview: "overview",
);

final testTvMap = {
  'id': 1,
  'name': 'name',
  'posterPath': 'posterPath',
  'overview': 'overview',
};
