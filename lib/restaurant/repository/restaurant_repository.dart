import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

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
