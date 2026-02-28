
import 'package:contact_app/core/language/core_language.dart';

abstract interface class ContactRepository{
  Future<Pair<List<CategoryModel>,List<ContactModel>>> readOrThrow();
  Future<List<ContactModel>> readContactsOrThrow(String category);
  Future<Pair<List<CategoryModel>,List<ContactModel>>> queryOrThrow({String? category,required String query});
}
class ContactModel{
  final String id,name;
  final String? contact, image;
  ContactModel({required this.id, required this.name,  this.contact,  this.image});
}
class CategoryModel{
  final String id,name;
  final String?  image;
  CategoryModel({required this.id, required this.name,this.image});
}