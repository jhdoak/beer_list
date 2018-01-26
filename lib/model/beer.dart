import '../beer_list.dart';
import '../model/restaurant.dart';

class Beer extends ManagedObject<_Beer> implements _Beer {}

class _Beer {
  @managedPrimaryKey
  int id;

  String brand;

  String name;

  double abv;

  @ManagedRelationship(#beer)
  Restaurant restaurant;
}