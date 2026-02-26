import 'dart:async';

import 'package:contact_app/core/ui/core_ui.dart' hide TextView;
import 'package:contact_app/features/_core/ui/_image_factory.dart';
import 'package:contact_app/features/contact_list/domain/contact_repository.dart';
import 'package:flutter/material.dart';
import '../../_core/core_ui.dart' show TextView, ThemeFactory, ButtonView;

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  @override
  Widget build(BuildContext context) {
    final padding=8.0;
    final statusBarPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: GestureDetector(
        onTap: (){
          showModalBottomSheet(
            showDragHandle: true,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return SaveContactPage();
            },
          );
        },
          child: SvgView(ImageFactory.fab)),
      body: Padding(
        padding: EdgeInsets.only(top:statusBarPadding),
        child: Column(
          children: [
            SpacerVertical(24),

            Padding(
              padding:  EdgeInsets.only(left: padding),
              child: _TopBar(),
            ),
            SpacerVertical(24),
           _ContactListHorizontal(contentPadding: padding),
            Expanded(
              child:Padding(
                padding:  EdgeInsets.symmetric(horizontal: padding),
                child: _ContactListVertical(),
              ) ,
            ),
          ],
        ),
      ),
    );
  }
}
class _ContactListHorizontal extends StatefulWidget {
  final double contentPadding;
  const _ContactListHorizontal({super.key, required this.contentPadding});
  @override
  State<_ContactListHorizontal> createState() => _ContactListHorizontalState();
}

class _ContactListHorizontalState extends State<_ContactListHorizontal> {
  var selected=0;
  @override
  Widget build(BuildContext context) {
    final model = ContactModel(
      id: '1',
      name: 'Md Khalekuzzaman',
      contact: '01571-378537',
      image: 'https://i.pravatar.cc/150?img=37',
    );
    final length = 10;
    return  SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            children: [
              if(index==0) SpacerHorizontal(widget.contentPadding),
              _Item2(model: model,isSelected: index==selected,
                onClick: (){
                  setState(() {
                    selected=index;
                  });
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

class _ContactListVertical extends StatelessWidget {
  const _ContactListVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ContactModel(
      id: '1',
      name: 'Md Khalekuzzaman',
      contact: '01571-378537',
      image: 'https://i.pravatar.cc/150?img=37',
    );
    final length = 10;
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: [
            SpacerVertical(10),
            _Item(model: model),
            SpacerVertical(10),
            if (index != length - 1) DividerHorizontal(),
          ],
        );
      },
      itemCount: length,
    );
  }
}


class _Item extends StatelessWidget {
  final ContactModel model;

  const _Item({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(model.image ?? ''),
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

class _Item2 extends StatelessWidget {
  final ContactModel model;
  final isSelected;
  final VoidCallback onClick;
  const _Item2({super.key, required this.model, this.isSelected = false,required this.onClick});

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
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(model.image ?? ''),
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
  const _TopBar({super.key});

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
        onQueryChanged: (query){},
        onDismiss: (){
          setState(() {
            showSearchBar=false;
          });
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
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onQueryChanged(query);
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
          border:Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            SpacerHorizontal(8),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  focusedBorder:InputBorder.none,
                ),
              ),
            ),
           InkWell(
               onTap: (){
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

// Reusable TextField Widget
class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType inputType;

  CustomTextField({
    required this.hintText,
    required this.controller,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

// Main UI
class SaveContactPage extends StatelessWidget {
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
                CustomTextField(hintText: 'Name', controller: nameController),
                CustomTextField(
                  hintText: 'Phone',
                  controller: phoneController,
                  inputType: TextInputType.phone,
                ),
                CustomTextField(
                    hintText: 'Designation', controller: designationController),
                CustomTextField(hintText: 'Company', controller: companyController),
                CustomDropdown(
                  hintText: 'Category',
                  selectedValue: null,
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
                    // Logic to save contact
                  },
                ),
                SpacerVertical(32),
                ButtonView(
                  label: 'Cancel',
                  background: Colors.white,
                  forground: ThemeFactory.theme.colorPrimary,
                  borderColor: Colors.black,
                  onPressed: () {
                    // Logic to cancel
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

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    required this.hintText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
          focusedBorder:  OutlineInputBorder()
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ))
            .toList(),
      ),
    );
  }
}