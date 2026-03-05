import 'package:contact_app/features/contact_list/domain/contact_repository.dart';

//@formater:off
abstract interface class ContactController {
  Stream<ContactUiState> get state;
  ContactUiState get initial;
  ContactUiState errorToState(Object? e);
  void onSelectCategory(int category);
  Future<void> read({String? category});
  Future<void> query({required String query});
  void dispose();
}

final class ContactUiState {
  final List<CategoryModel> categories;
  final List<ContactModel> contacts;
  final String? error;
  final int? selectedCategory;
  final bool isLoading;

  const ContactUiState({
    required this.categories,
    required this.contacts,
    required this.error,
    required this.isLoading,
    required this.selectedCategory,
  });

  ContactUiState copyWith({
    List<CategoryModel>? categories,
    List<ContactModel>? contacts,
    String? error,
    bool? isLoading,
    int? selectedCategory,
  }) {
    return ContactUiState(
      categories: categories ?? this.categories,
      contacts: contacts ?? this.contacts,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  static ContactUiState toEmpty() {
    return ContactUiState(
      categories: [],
      contacts: [],
      error: null,
      isLoading: false,
      selectedCategory: null,
    );
  }
}
