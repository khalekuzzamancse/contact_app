import 'package:contact_app/core/data/api/contact_api.dart';
import 'package:contact_app/core/language/core_language.dart';
import 'package:contact_app/features/contact_list/domain/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository  {
  final ContactApi api;
  ContactRepositoryImpl(this.api);
  @override
  Future<Pair<List<CategoryModel>,List<ContactModel>>> queryOrThrow({String? category, required String query})async {
    final response=await api.queryOrThrow(category: category, query: query);
    return Pair(mapCategory(response.first), mapContact(response.second));
  }
  @override
  Future<Pair<List<CategoryModel>,List<ContactModel>>> readOrThrow() async{
    final response=await api.readOrThrow();
    return Pair(mapCategory(response.first), mapContact(response.second));
  }
  List<CategoryModel> mapCategory(List<CategoryEntity> entities){
    return entities.map((e) => CategoryModel(id: e.id, name: e.name, image: e.image)).toList();
  }
  List<ContactModel> mapContact(List<ContactEntity> entities){
    return entities.map((e) => ContactModel(id: e.id, name: e.name, contact: e.contact, image: e.image)).toList();
  }

  @override
  Future<List<ContactModel>> readContactsOrThrow(String category)async {
    final response=await api.readContactsOrThrow(category: category);
    return mapContact(response);
  }
}
