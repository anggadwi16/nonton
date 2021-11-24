import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMovieBloc popularMovieBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  group(
    'Popular Movie',
    () {
      blocTest<PopularMovieBloc, PopularMovieState>(
        'Should emit [Loading, Loaded] when get popular movie successful',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return popularMovieBloc;
        },
        act: (bloc) => bloc.add(LoadPopularMovie()),
        expect: () => <PopularMovieState>[
          PopularMovieLoading(),
          PopularMovieLoaded(),
        ],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        },
      );

      blocTest<PopularMovieBloc, PopularMovieState>(
        'Should emit [Loading, Error] when get popular movie unsuccessful',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return popularMovieBloc;
        },
        act: (bloc) => bloc.add(LoadPopularMovie()),
        expect: () => <PopularMovieState>[
          PopularMovieLoading(),
          PopularMovieError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        },
      );
    },
  );
}
