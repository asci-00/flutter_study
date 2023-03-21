import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';
import '../../common/dio/dio.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../common/const/data.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final restaurantRepository =
      RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return restaurantRepository;
});

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/')
  Future<CursorPagination<RestaurantModel>> getRestaurantList();

  @Headers({'accessToken': true})
  @GET('/{id}')
  Future<RestaurantDetailModel> getRestaurant(@Path() String id);
}
