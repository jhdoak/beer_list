import '../beer_list.dart';
import '../model/beer.dart';

class Restaurant extends ManagedObject<_Restaurant> implements _Restaurant {}

class _Restaurant {
  @managedPrimaryKey
  int id;

  String name;

  String address;

  String phoneNumber;

  ManagedSet<Beer> beers;
}