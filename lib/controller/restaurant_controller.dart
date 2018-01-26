import '../beer_list.dart';
import 'package:beer_list/model/restaurant.dart';

class RestaurantController extends HTTPController {

  @httpGet
  Future<Response> getAllRestaurants() async {
    var restaurantQuery = new Query<Restaurant>();

    var restaurants = await restaurantQuery.fetch();

    return new Response.ok(restaurants);
  }
}