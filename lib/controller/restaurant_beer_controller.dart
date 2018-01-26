import '../beer_list.dart';
import 'package:beer_list/model/restaurant.dart';

class RestaurantBeerController extends HTTPController {

  @httpGet
  Future<Response> getAllBeersByRestaurant(@HTTPPath("id") int id) async {

    var restaurantBeerQuery = new Query<Restaurant>()
      ..join(set: (restaurant) => restaurant.beers)
      ..where.id = whereEqualTo(id);

    var restaurantWithBeers = await restaurantBeerQuery.fetch();

    return new Response.ok(restaurantWithBeers);
  }
}