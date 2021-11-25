import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTv(mockTvRepository);
  });

  final tTv = <Tv>[];

  group('GetPopularTv test', () {
    group('execute', () {
      test(
          'should get list of tv ffrom repository when execute function is called',
          () async {
        when(mockTvRepository.getPopularTv())
            .thenAnswer((_) async => Right(tTv));
        final result = await usecase.execute();
        expect(result, Right(tTv));
      });
    });
  });
}
