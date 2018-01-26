import '../beer_list.dart';

class BeerController extends HTTPController {

  @httpGet
  Future<Response> getAllBeers() async {
    return new Response.ok("ok");
  }
}