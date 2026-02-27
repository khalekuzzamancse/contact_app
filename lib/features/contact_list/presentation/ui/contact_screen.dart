import 'dart:async';
import 'package:contact_app/core/ui/core_ui.dart' hide TextView;
import 'package:contact_app/features/_core/di.dart';
import 'package:contact_app/features/_core/ui/_image_factory.dart';
import 'package:contact_app/features/contact_list/domain/contact_repository.dart';
import 'package:contact_app/features/contact_list/presentation/logic/contact_controller.dart';
import 'package:flutter/material.dart';
import '../../../_core/core_ui.dart' show TextView, ThemeFactory, ButtonView, TextFieldView, DropdownView, PhoneNumberPicker;

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  _ContactScreen();
  }
}

class _ContactScreen extends StatefulWidget {
  const _ContactScreen({super.key});
  @override
  State<_ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<_ContactScreen> with LoadingStateMixin {
  late final controller=DiContainer.controller();
  List<CategoryModel> categories=[];
  List<ContactModel> contacts=[];

  @override
  void initState() {
    super.initState();
    super.isLoading=true;
    read();
    controller.categories.listen((event){
      categories=event;
    });
    controller.contacts.listen((event){
      contacts=event;
    });

  }
  void read()async{
    startLoading();
    await controller.read();
    stopLoading();
  }
  @override
  Widget build(BuildContext context) {
    final padding=8.0;
    final statusBarPadding = MediaQuery.of(context).padding.top;
    final isEmpty=(!isLoading&&categories.isEmpty&&contacts.isEmpty);
    return LoadingOverlay(
      isLoading: isLoading,
      child:Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: GestureDetector(
          onTap: (){
            _showBottomSheet(context);
          },
            child: SvgView(ImageFactory.fab)),
        body: isEmpty?Center(child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: NoContactView(),
        )):Padding(
          padding: EdgeInsets.only(top:statusBarPadding),
          child: Column(
            children: [
              SpacerVertical(24),
              Padding(
                padding:  EdgeInsets.only(left: padding),
                child: _TopBar(controller: controller,onQueryChanged: (value)async{
                  startLoading();
                  await controller.query(query: value);
                  stopLoading();
                },
                  onDismissSearch: (){
                  read();
                  },
                ),
              ),
              SpacerVertical(24),
             _ContactListHorizontal(
               contentPadding: padding,controller: controller,
               onCategoryChanged: (value)async{
                 controller.onCategoryChanged(value);
                 startLoading();
                 await controller.read(category: value);
                 stopLoading();
               }
             ),
              Expanded(
                child:Padding(
                  padding:  EdgeInsets.symmetric(horizontal: padding),
                  child: _ContactListVertical(controller: controller),
                ) ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _ContactListHorizontal extends StatefulWidget {
  final ContactController controller;
  final double contentPadding;
  final Function(String) onCategoryChanged;
  const _ContactListHorizontal({super.key, required this.contentPadding, required this.controller, required this.onCategoryChanged});
  @override
  State<_ContactListHorizontal> createState() => _ContactListHorizontalState();
}
class _ContactListHorizontalState extends State<_ContactListHorizontal> {
  List<CategoryModel> contacts=[];
  var selected=0;
  @override
  initState(){
    super.initState();
    widget.controller.categories.listen((event) {
      safeSetState(() {
        contacts=event;
      });
    });
  }
  @override
  void didUpdateWidget(covariant _ContactListHorizontal oldWidget) {
    super.didUpdateWidget(oldWidget);
    try{
      widget.controller.onCategoryChanged(contacts[selected].name);
    }
    catch(_){}
  }
  @override
  Widget build(BuildContext context) {
    final models=contacts;
    final length = models.length;
    return  SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            children: [
              if(index==0) SpacerHorizontal(widget.contentPadding),
              _CategoryView(model: models[index],isSelected: index==selected,
                onClick: ()async{
                try{
                  setState(() {
                    selected=index;
                  });
                  try{
                    widget.onCategoryChanged(contacts[index].name);
                  }
                  catch(_){}
                }
                catch(_){}

                },
              ),
              SpacerHorizontal(8),
            ],
          );
        },
        itemCount: length,
      ),
    );
  }
}
class _ContactListVertical extends StatefulWidget {
  final ContactController controller;
  const _ContactListVertical({super.key, required this.controller});

  @override
  State<_ContactListVertical> createState() => _ContactListVerticalState();
}

class _ContactListVerticalState extends State<_ContactListVertical> {
  List<ContactModel> contacts=[];
  @override
  initState() {
    super.initState();
    widget.controller.contacts.listen((event) {
      safeSetState(() {
        contacts=event;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final models=contacts;
    final length = models.length;
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: [
            SpacerVertical(10),
            _ContactView(model: models[index]),
            SpacerVertical(10),
            if (index != length - 1) DividerHorizontal(),
          ],
        );
      },
      itemCount: length,
    );
  }
}
class _ContactView extends StatelessWidget {
  final ContactModel model;

  const _ContactView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        model.image==null? InitialsAvatar(name: model.name,radius: 30,): CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(model.image!),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView(model.name, fontSize: 20, color: Color(0xFF475569)),
            TextView(
              model.contact ?? 'N/A',
              color: Color(0xFF64758B),
              fontSize: 15,
            ),
          ],
        ),
      ],
    );
  }
}
class _CategoryView extends StatelessWidget {
  final CategoryModel model;
  final isSelected;
  final VoidCallback onClick;
  const _CategoryView({super.key, required this.model, this.isSelected = false,required this.onClick});

  @override
  Widget build(BuildContext context) {
    final primary = ThemeFactory.theme.colorPrimary;
    return SizedBox(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected?primary:Colors.transparent, width: 2)),
            child: GestureDetector(
              onTap: onClick,
              child: model.image==null? InitialsAvatar(name: model.name,radius: 40,):CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(model.image!),
              ),
            ),
          ),
          SpacerVertical(8),
          TextView(
            model.name,
            fontSize: 16,
            color: isSelected ? primary : Color(0xFF475569),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
class _TopBar extends StatefulWidget {
  final ContactController controller;
  final Function(String) onQueryChanged;
  final VoidCallback onDismissSearch;
  const _TopBar({super.key, required this.controller, required this.onQueryChanged, required this.onDismissSearch});

  @override
  State<_TopBar> createState() => _TopBarState();
}
class _TopBarState extends State<_TopBar> {
  var selected=0;
  var showSearchBar=false;

  @override
  Widget build(BuildContext context) {
    if(showSearchBar){
      return SearchBar(
        onQueryChanged: widget.onQueryChanged,
        onDismiss: (){
          setState(() {
            showSearchBar=false;
          });
          widget.onDismissSearch();
        },

      );
    }
    else{
      return Row(
        children: [
          _SelectableText(
            selected: selected==0,
            label: 'Contact',
            onClick: (){
              setState(() {
                selected=0;
              });
            },
          ),
          SpacerHorizontal(16),
          _SelectableText(
            selected: selected==1,
            label: 'Recent',
            onClick: (){
              setState(() {
                selected=1;
              });
            },
          ),
          Spacer(),
          InkWell(
              child: SvgView(ImageFactory.ic_search,width: 30),
              onTap: (){
                setState(() {
                  showSearchBar=true;
                });
              }
          ),
          SpacerHorizontal(24),
          SvgView(ImageFactory.ic_menu,width: 30),
          SpacerHorizontal(16),
        ],
      );
    }

  }
}
class _SelectableText extends StatelessWidget {
  final String label;
  final VoidCallback onClick;
  final bool selected;
  const _SelectableText({super.key, required this.selected, required this.label, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final primary = ThemeFactory.theme.colorPrimary;
    return SizedBox(
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: onClick,
              child: TextView(
                label,
                  fontSize: 20,
                  color: selected ? Colors.black : Colors.grey,
              ),
            ),
          ),
          if(selected)
          Container(
            width: double.infinity,
            height: 1.5,
            decoration: BoxDecoration(
              color:primary,
            ),
          ),
        ],
      ),
    );
  }
}
class SearchBar extends StatefulWidget {
  final Function(String query) onQueryChanged;
  final VoidCallback onDismiss;
  const SearchBar({super.key, required this.onQueryChanged, required this.onDismiss});

  @override
  _SearchBarState createState() => _SearchBarState();
}
class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  var query='';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds:1500), () {
      widget.onQueryChanged(query);
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        query = _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border:Border.all(color:Color(0xFFCBD5E1)),
        ),
        child: Row(
          children: [
            SpacerHorizontal(16),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: ThemeFactory.theme.font,
                ),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Color(0xFF94A3B8),
                      fontFamily: ThemeFactory.theme.font,fontSize: 16),
                  border: InputBorder.none,
                  focusedBorder:InputBorder.none,
                ),
              ),
            ),
           InkWell(
               onTap: (){
                 FocusScope.of(context).requestFocus(FocusNode());
                 _controller.text='';
                 if(query.isNotEmpty){
                   setState(() {
                     query='';
                   });
                 }

                 widget.onDismiss();
               },
               child: Icon(Icons.clear,color:Color(0xFF4B5563))),
            SpacerHorizontal(8),

          ],
        ),
      ),
    );
  }
}
// Main UI
class SaveContactPage extends StatefulWidget {
  @override
  State<SaveContactPage> createState() => _SaveContactPageState();
}
class _SaveContactPageState extends State<SaveContactPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController relationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
          mainAxisSize: MainAxisSize.min,
        children: [
          SpacerVertical(24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldView(hintText: 'Name', controller: nameController),
                PhoneNumberPicker(
                    onCountryCodeChanged: (_ ) {  },
                    onNumberChanged: (_ ) {  },
                  onFullNumberChanged: (_ ) {  },),
                TextFieldView(
                    hintText: 'Designation', controller: designationController),
                TextFieldView(hintText: 'Company', controller: companyController),
                DropdownView(
                  hintText: 'Category',
                  selectedValue:'Relation',
                  items: ['Relation', 'Family', 'Work', 'Other'],
                  onChanged: (value) {
                  },
                ),
                SizedBox(height: 20),
                ButtonView(
                  label: 'Save Contact',
                  background: ThemeFactory.theme.colorPrimary,
                  forground: Colors.white,
                  onPressed: () {
                    showSnackBar('Not implement yet');
                    context.pop();
                  },
                ),
                SpacerVertical(32),
                ButtonView(
                  label: 'Cancel',
                  background: Colors.white,
                  labelColor: Color(0xFF717978),
                  forground: ThemeFactory.theme.colorPrimary,
                  borderColor: Color(0xFF717978),
                  onPressed: () {
                    context.pop();
                  },
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}


class InitialsAvatar extends StatelessWidget {
  final double radius;
  final String name;
  const InitialsAvatar({Key? key, required this.name,required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(0xFFB2D95A),
      child: TextView(
        initials,
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
      ),
    );
  }
}
class _ContactProvider extends InheritedWidget {
   final ContactController controller;

  const _ContactProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  static ContactController controllerOrThrow(BuildContext context) {
    final _ContactProvider? result =
    context.dependOnInheritedWidgetOfExactType<_ContactProvider>();
    assert(result != null, 'No ContactControllerInheritedWidget found in context');
    return result!.controller;
  }
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true; // Always notify
  }
}

class NoContactView extends StatelessWidget {
  const NoContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                'Ee! No Contacts found.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: ThemeFactory.theme.font,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569)),
              ),
            ),
            SizedBox(height: 20),
            ButtonView(
                label: 'Add New Contact',
                background: ThemeFactory.theme.colorPrimary,
                forground: Colors.white,
                onPressed: (){
                  _showBottomSheet(context);
                })
          ],
        ),
      ),
    );
  }
}
void _showBottomSheet(BuildContext context){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpacerVertical(32),
          Container(
            height: 30,
            color: Colors.white,
            child: Center(
              child: Container(
                height: 10,
                width: 250,
                decoration: BoxDecoration(
                  color:  Color(0xFF8C8C8C).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SaveContactPage(),
        ],
      );
    },
  );
}