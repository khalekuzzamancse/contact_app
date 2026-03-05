import 'package:contact_app/core/language/core_language.dart';
import 'package:contact_app/features/_core/error_controller.dart';
import 'package:contact_app/features/contact_list/domain/contact_repository.dart';
import 'contact_controller.dart';
import 'package:rxdart/rxdart.dart';

class ContactControllerImpl implements ContactController {
  late  ContactUiState last=ContactUiState.toEmpty();
  final ContactRepository repository;
  @override
  late final initial=last;
  late final _state = BehaviorSubject<ContactUiState>.seeded(last);
  ContactControllerImpl(this.repository);
  @override
  Stream<ContactUiState> get state => _state.stream;
  @override
  ContactUiState errorToState(Object? e) {
    if(e!=null){
      ErrorController.showSnackBarOrSkip(e);
    }
    return last;
  }
  @override
  void onSelectCategory(int category) {
    _state.add(updatedState(selected: category));
  }
  @override
  Future<void> read({String? category}) async {
    try{
      if(category==null){
        //clear existing
        _state.add(updatedState(isLoading: true));
        final response=await repository.readOrThrow();
        _state.add(updatedState(isLoading: false, contacts: response.second, categories: response.first));
      }
      else{
        //clear existing
        _state.add(updatedState(isLoading: true));
        final response=await repository.readContactsOrThrow(category);
        last=last.copyWith(isLoading: false, contacts: response);
        _state.add(updatedState(isLoading: false,contacts: response));
      }
    }
    catch(e){
      _state.add(updatedState(isLoading: false));
      ErrorController.showSnackBarOrSkip(e);
    }
  }
  @override
  Future<void> query({required String query}) async {
    try{
      final category=categoryOrNull();
      if(category==null){return;}
      _state.add(updatedState(isLoading: true));
      final response=await repository.queryOrThrow(category:category,query: query);
      _state.add(updatedState(isLoading: false, contacts: response.second, categories: response.first));
    }
    catch(e) {
      _state.add(updatedState(isLoading: false));
      ErrorController.showSnackBarOrSkip(e);
    }
  }

  String? categoryOrNull(){
    try{
      return last.categories[last.selectedCategory!].name;
    }
    catch(_){
      return null;
    }
  }

  ContactUiState updatedState(
      {List<CategoryModel>? categories,
      List<ContactModel>? contacts,
      String? error,
      bool? isLoading,
      int? selected}){
     last=last.copyWith(categories: categories, contacts: contacts, error: error, isLoading: isLoading, selectedCategory: selected);
    return last;
  }
  @override
  void dispose() {
    _state.close();
  }
}