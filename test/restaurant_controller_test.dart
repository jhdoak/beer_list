import 'harness/app.dart';
import 'package:beer_list/model/restaurant.dart';

Future main() async {
  TestApplication app = new TestApplication();

  setUpAll(() async {
    await app.start();

    var restaurants = [
      new Restaurant()
        ..name = "Ladybird"
        ..address = "684 John Wesley Dobbs Ave NE, Atlanta, GA 30312"
        ..phoneNumber = "(404) 458-6838",
      new Restaurant()
        ..name = "Bantam Pub"
        ..address = "737 Ralph McGill Blvd NE, Atlanta, GA 30312"
        ..phoneNumber = "(404) 223-1500",
      new Restaurant()
        ..name = "Murphy's"
        ..address = "997 Virginia Ave NE, Atlanta, GA 30306"
        ..phoneNumber = "(404) 872-0904"
    ];

    await Future.forEach(restaurants, (r) {
      var restaurantQuery = new Query<Restaurant>()
          ..values = r;
      return restaurantQuery.insert();
    });

  });

  tearDownAll(() async {
    await app.stop();
  });


  test("/restaurants returns all restaurants", () async {
    expectResponse(
      await app.client.request("/restaurants").get(),
      200,
      body: allOf([
        hasLength(3),
        everyElement(containsPair("id", greaterThan(0))),
        everyElement(containsPair("name", isNotEmpty)),
        everyElement(containsPair("address", isString)),
        everyElement(containsPair("phoneNumber", isString))
      ]));
  });

  test("/restaurants/id returns a specific restaurant", () async {
    expectResponse(
      await app.client.request("/restaurants/3").get(),
      200,
      body: allOf([
        containsPair("id", 3),
        containsPair("name", "Murphy's"),
        containsPair("address", "997 Virginia Ave NE, Atlanta, GA 30306"),
        containsPair("phoneNumber", "(404) 872-0904")
      ]));
  });

  test("/restaurants creates a new restaurant", () async {
    var request = app.client.request("/restaurants")
      ..json = {
        "name": "Test Restaurant",
        "address": "123 Main Street",
        "phoneNumber": "(123) 456-7890"
      };

    expectResponse(
        await request.post(),
        200,
        body: allOf([
          containsPair("name", "Test Restaurant"),
          containsPair("address", "123 Main Street"),
          containsPair("phoneNumber", "(123) 456-7890")
        ]));
  });

  test("/restaurants/:id retrieves a newly created restaurant", () async {
    var request = app.client.request("/restaurants")
      ..json = {
        "name": "Test Restaurant",
        "address": "123 Main Street",
        "phoneNumber": "(123) 456-7890"
      };

    var postResponse = await request.post();
    var createdRestaurantId = postResponse.asMap["id"];

    var getResponse = await app.client.request("/restaurants/$createdRestaurantId").get();

    expectResponse(
        getResponse,
        200,
        body: allOf([
          containsPair("id", createdRestaurantId),
          containsPair("name", "Test Restaurant"),
          containsPair("address", "123 Main Street"),
          containsPair("phoneNumber", "(123) 456-7890")
        ]));
  });

}