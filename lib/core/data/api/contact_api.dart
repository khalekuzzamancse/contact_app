
import '../../language/core_language.dart';

abstract interface class ContactApi{
  Future<Pair<List<CategoryEntity>,List<ContactEntity>>> readOrThrow();
  Future<List<ContactEntity>> readContactsOrThrow({String? category});
  Future<Pair<List<CategoryEntity>,List<ContactEntity>>>  queryOrThrow({String? category,required String query});
}
class ContactEntity{
  final String id,name;
  final String? contact, image;
  ContactEntity({required this.id, required this.name,  this.contact,  this.image});
}
class CategoryEntity{
  final String id,name;
  final String?  image;
  CategoryEntity({required this.id, required this.name,this.image});
}