import 'package:contact_app/core/language/core_language.dart';
import 'package:contact_app/features/_core/error_controller.dart';
import 'package:contact_app/features/contact_list/domain/contact_repository.dart';
import 'contact_controller.dart';
import 'package:rxdart/rxdart.dart';

class ContactControllerImpl implements ContactController{
  final ContactRepository repository;
  ContactControllerImpl(this.repository);
  late final tag=runtimeType.toString();
  final _contacts=BehaviorSubject<List<ContactModel>>.seeded(List.empty());
  final _categories=BehaviorSubject<List<CategoryModel>>.seeded(List.empty());
  String? _selectedCategory;
  @override
  Stream<List<CategoryModel>> get categories=>_categories.stream;
  @override
  Stream<List<ContactModel>> get contacts => _contacts.stream;
  @override
  Future<void> query({required String query}) async{
    try{
      final category=_selectedCategory;
      Logger.on(tag, 'category:$category,query:$query');
      if(category==null){
        return;
      }
      final response=await repository.queryOrThrow(category:category,query: query);
      _contacts.add(response.second);
      _categories.add(response.first);
    }
    catch(e) {
      ErrorController.showSnackBarOrSkip(e);
      Logger.on(tag, 'exception:$e');
    }
  }

  @override
  Future<void> read({String? category}) async{
    try{
      if(category==null){
        final response=await repository.readOrThrow();
        _contacts.add(response.second);
        _categories.add(response.first);
      }
      else{
        final response=await repository.readContactsOrThrow(category);
        _contacts.add(response);
      }
    }
    catch(e){
      ErrorController.showSnackBarOrSkip(e);
      Logger.on(tag, 'exception:$e');
    }
  }

  @override
  void onCategoryChanged(String category) {
    _selectedCategory=category;
  }


}