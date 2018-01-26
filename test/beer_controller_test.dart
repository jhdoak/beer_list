import 'harness/app.dart';
import 'package:beer_list/model/beer.dart';

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

    await Future.forEach(beers, (b) {
      var beerQuery = new Query<Beer>()
        ..values = b;
      return beerQuery.insert();
    });

  });

  tearDownAll(() async {
    await app.stop();
  });


  test("/beers returns all beers", () async {
    expectResponse(
        await app.client.request("/beers").get(),
        200,
        body: allOf([
          hasLength(3),
          everyElement(containsPair("id", greaterThan(0))),
          everyElement(containsPair("brand", isNotEmpty)),
          everyElement(containsPair("name", isNotEmpty)),
          everyElement(containsPair("abv", isDouble))
        ]));
  });

  test("/beers/id returns a specific beer", () async {
    expectResponse(
        await app.client.request("/beers/1").get(),
        200,
        body: allOf([
          containsPair("id", 1),
          containsPair("brand", "Blue Moon"),
          containsPair("name", "Belgian White"),
          containsPair("abv", 5.4)
        ]));
  });

}