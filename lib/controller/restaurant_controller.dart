import '../beer_list.dart';
import 'package:beer_list/model/restaurant.dart';

class RestaurantController extends HTTPController {

  @httpGet
  Future<Response> getAllRestaurants() async {
    var restaurantQuery = new Query<Restaurant>();

    var restaurants = await restaurantQuery.fetch();

    return new Response.ok(restaurants);
  }

  @httpGet
  Future<Response> getRestaurantById(@HTTPPath("id") int id) async {
    var restaurantQuery = new Query<Restaurant>()
        ..where.id = whereEqualTo(id);

    var restaurant = await restaurantQuery.fetchOne();

    return (restaurant == null)
        ? new Response.notFound()
        : new Response.ok(restaurant);
  }
}