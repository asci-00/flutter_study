import 'package:delivery_app/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dio = Dio();

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // todo: 수정해야 함 access token 재발급
    final token = await storage.read(key: accessTokenKey);
    options.headers.addAll({'authorization': 'Bearer $token'});

    // if (options.headers['accessToken']) {
    //   options.headers.remove('accessToken');
    //
    //   final token = await storage.read(key: accessTokenKey);
    //   options.headers.addAll({'authorization': 'Bearer $token'});
    // }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final refreshToken = await storage.read(key: refreshTokenKey);

    // unhandled error
    if (refreshToken == null ||
        err.response?.statusCode != 401 ||
        err.requestOptions.path == '/auth/token') {
      return handler.reject(err);
    }

    // access token expired
    try {
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
      );

      final accessToken = resp.data['accessToken'];

      storage.write(key: accessTokenKey, value: accessToken);

      err.requestOptions.headers
          .addAll({'authorization': 'Bearer $accessToken'});

      final reResp = await dio.fetch(err.requestOptions);
      return handler.resolve(reResp);
    } on DioError catch (e) {
      return handler.reject(e);
    }
  }
}
