import '../beer_list.dart';
import 'package:beer_list/model/beer.dart';
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

  @httpPost
  Future<Response> createBeerForRestaurant(@HTTPPath("id") int restaurantId, @HTTPBody() Beer beer) async {

    var restaurantQuery = new Query<Restaurant>()
        ..where.id = whereEqualTo(restaurantId);

    var restaurant = await restaurantQuery.fetchOne();

    if (restaurant == null) {
      return new Response.notFound();
    }

    var beerQuery = new Query<Beer>()
      ..values = beer
      ..values.restaurant = restaurant;

    var insertedBeer = await beerQuery.insert();

    return new Response.ok(insertedBeer);

  }
}