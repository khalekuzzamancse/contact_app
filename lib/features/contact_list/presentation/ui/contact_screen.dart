import 'package:contact_app/core/language/core_language.dart';
import 'package:contact_app/core/ui/core_ui.dart' hide TextView;
import 'package:contact_app/features/_core/di.dart';
import 'package:contact_app/features/_core/ui/_image_factory.dart';
import 'package:contact_app/features/contact_create/save_contact.dart';
import 'package:contact_app/features/contact_list/domain/contact_repository.dart';
import 'package:contact_app/features/contact_list/presentation/logic/contact_controller.dart';
import 'package:flutter/material.dart' hide showBottomSheet;
import 'package:provider/provider.dart';
import '_.dart';

class ContactScreen extends StatefulWidget {
   const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}
class _ContactScreenState extends State<ContactScreen> {
  final controller = DiContainer.controller2();
  @override
  void initState() {
    super.initState();
    controller.read();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ContactController>(create: (_) => controller),
        StreamProvider<ContactUiState>.value(
          value: controller.state,
          initialData: controller.initial,
          catchError: (context, error) => controller.errorToState(error),
        ),
      ],
      child: const _ContactListScreen(),
    );
  }
}
class _ContactListScreen extends StatelessWidget {
  const _ContactListScreen();
  @override
  Widget build(BuildContext context) {
    final isLoading=context.select<ContactUiState, bool>((state) => state.isLoading);
    Logger.on('ContactListScreen', "build()");
    return LoadingOverlay(
      isLoading: isLoading,
      child:const Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: _Fab(),
        body:  Column(
          children: [
            SpacerVertical(32),
            _Appbar(),
             _Categories(),
             _Contacts(),
          ],
        ),
      ),
    );
  }
}
class _Fab extends StatelessWidget {
  const _Fab();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:  SvgView(ImageFactory.fab),
      onTap: () {
        showAddContactSheet(context);
      },
    );
  }
}
class _Appbar extends StatelessWidget {
  const _Appbar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: TopBar(
        onQueryChanged: (value) async {
          context.read<ContactController>().query(query: value);
        },
        onDismissSearch: () {
          context.read<ContactController>().read();
        },
      ),
    );
  }
}
class _Categories extends StatelessWidget {
  const _Categories();
  @override
  Widget build(BuildContext context) {
    final categories = context.select<ContactUiState, List<CategoryModel>>((state) => state.categories);
    final selected = context.select<ContactUiState, int?>((state) => state.selectedCategory);
    return CategoriesView(
        categories: categories,
        selected: selected,
        onSelected: (index) {
          context.read<ContactController>().onSelectCategory(index);
        });
  }
}
class _Contacts extends StatelessWidget {
  const _Contacts();
  @override
  Widget build(BuildContext context) {
    final contacts = context.select<ContactUiState, List<ContactModel>>((state) => state.contacts);
    final isLoading=context.select<ContactUiState, bool>((state) => state.isLoading);
    if (!isLoading &&contacts.isEmpty) {
      return NoContactView();
    } else {
      return Expanded(child: ContactsViews(contacts));
    }
  }
}