import '../beer_list.dart';
import 'package:beer_list/model/beer.dart';

class BeerController extends HTTPController {

  @httpGet
  Future<Response> getAllBeers() async {
    var beerQuery = new Query<Beer>();

    var beers = await beerQuery.fetch();

    return new Response.ok(beers);
  }

  @httpGet
  Future<Response> getBeerById(@HTTPPath("id") int id) async {
    var beerQuery = new Query<Beer>()
      ..where.id = whereEqualTo(id);

    var beer = await beerQuery.fetchOne();

    return (beer == null)
        ? new Response.notFound()
        : new Response.ok(beer);
  }
}