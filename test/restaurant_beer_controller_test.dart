import 'harness/app.dart';
import 'package:beer_list/model/beer.dart';
import 'package:beer_list/model/restaurant.dart';

Future main() async {
  TestApplication app = new TestApplication();

  setUpAll(() async {
    await app.start();

    var beers = [
      new Beer()
        ..brand = "Blue Moon"
        ..name = "Belgian White"
        ..abv = 5.4,
      new Beer()
        ..brand = "Yuengling"
        ..name = "Lager"
        ..abv = 4.4,
      new Beer()
        ..brand = "Dos Equis"
        ..name = "Special Lager"
        ..abv = 4.3
    ];

    var restaurants = [
      new Restaurant()
        ..name = "Ladybird"
        ..address = "684 John Wesley Dobbs Ave NE, Atlanta, GA 30312"
        ..phoneNumber = "(404) 458-6838"
        ..beers = new ManagedSet.from(beers),
      new Restaurant()
        ..name = "Bantam Pub"
        ..address = "737 Ralph McGill Blvd NE, Atlanta, GA 30312"
        ..phoneNumber = "(404) 223-1500",
      new Restaurant()
        ..name = "Murphy's"
        ..address = "997 Virginia Ave NE, Atlanta, GA 30306"
        ..phoneNumber = "(404) 872-0904"
    ];

    await Future.forEach(restaurants, (Restaurant r) async {
      var restaurantQuery = new Query<Restaurant>()
        ..values = r;

      var insertedRestaurant = await restaurantQuery.insert();
      
      await Future.forEach(r.beers, (Beer b) async {
        var beerQuery = new Query<Beer>()
            ..values = b
            ..values.restaurant = r;

        await beerQuery.insert();
      });

      return insertedRestaurant;
    });

  });

  tearDownAll(() async {
    await app.stop();
  });


  test("/restaurants/id/beers returns a restaurant's beers", () async {
    expectResponse(
        await app.client.request("/restaurants/1/beers").get(),
        200,
        body: allOf([
          hasLength(3),
          everyElement(containsPair("id", greaterThan(0))),
          everyElement(containsPair("brand", isNotEmpty)),
          everyElement(containsPair("name", isNotEmpty)),
          everyElement(containsPair("abv", isDouble))
        ]));
  });

}