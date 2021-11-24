
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/http_ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  group('SSL Pinning', () {
    test('Should get response 200 when success connect', () async{
      final client = await Shared.createLEClient(isTestMode: true);
      final response = await client.get(Uri.parse('${TvRemoteDataSourceImpl
          .BASE_URL}/tv/popular?${TvRemoteDataSourceImpl.API_KEY}'));
      expect(response.statusCode, 200);
      client.close();
    });
  });
}