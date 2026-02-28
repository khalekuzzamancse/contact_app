import 'package:contact_app/features/contact_list/domain/contact_repository.dart';
abstract interface class ContactController{
  Stream<List<ContactModel>> get contacts;
  Stream<List<CategoryModel>> get categories;
  void onCategoryChanged(String category);
  Future<void> read({String? category});
  Future<void> query({required String query});
  void dispose();

}