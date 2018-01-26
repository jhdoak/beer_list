import '../beer_list.dart';

class RestaurantController extends HTTPController {

  @httpGet
  Future<Response> getAllRestaurants() async {
    return new Response.ok("ok");
  }
}