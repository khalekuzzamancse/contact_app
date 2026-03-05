import 'dart:async';
import 'package:contact_app/core/ui/core_ui.dart' hide TextView;
import 'package:contact_app/features/_core/core_ui.dart';
import 'package:contact_app/features/_core/ui/_image_factory.dart';
import 'package:contact_app/features/contact_create/save_contact.dart';
import 'package:contact_app/features/contact_list/domain/contact_repository.dart';
import 'package:flutter/material.dart';

//Define the core raw component that can easily usable with any state-management solution
//either directly or by a simple wrapper

class CategoriesView extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selected;
  final Function(int) onSelected;
  const CategoriesView({super.key,required this.categories,this.selected,required this.onSelected,});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            children: [
              if (index == 0) SpacerHorizontal(8),
              _CategoryView(
                model: categories[index],
                isSelected: index == selected,
                onClick: () {
                  onSelected(index);
                },
              ),
              SpacerHorizontal(8),
            ],
          );
        },
        itemCount: categories.length,
      ),
    );
  }
}
class _CategoryView extends StatelessWidget {
  final CategoryModel model;
  final bool isSelected;
  final VoidCallback onClick;

  const _CategoryView({
    required this.model,
    this.isSelected = false,
    required this.onClick,
  });

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
              border: Border.all(
                color: isSelected ? primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: GestureDetector(
              onTap: onClick,
              child: model.image == null
                  ? InitialsAvatar(name: model.name, radius: 40)
                  : CircleAvatar(
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
class ContactsViews extends StatelessWidget {
  final List<ContactModel> models;
  const ContactsViews(this.models,{super.key});
  @override
  Widget build(BuildContext context) {
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

  const _ContactView({required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        model.image == null
            ? InitialsAvatar(name: model.name, radius: 30)
            : CircleAvatar(
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
class InitialsAvatar extends StatelessWidget {
  final double radius;
  final String name;

  const InitialsAvatar({super.key, required this.name, required this.radius});

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
class NoContactView extends StatelessWidget {
  const NoContactView({super.key});

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
                  color: Color(0xFF475569),
                ),
              ),
            ),
            SizedBox(height: 20),
            ButtonView(
              label: 'Add New Contact',
              background: ThemeFactory.theme.colorPrimary,
              forground: Colors.white,
              onPressed: () {
                showAddContactSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
class TopBar extends StatefulWidget {
  final Function(String) onQueryChanged;
  final VoidCallback onDismissSearch;

  const TopBar({required this.onQueryChanged, required this.onDismissSearch});

  @override
  State<TopBar> createState() => _TopBarState();
}
class _TopBarState extends State<TopBar> {
  var selected = 0;
  var showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    if (showSearchBar) {
      return _SearchBar(
        onQueryChanged: widget.onQueryChanged,
        onDismiss: () {
          setState(() {
            showSearchBar = false;
          });
          widget.onDismissSearch();
        },
      );
    } else {
      return Row(
        children: [
          SelectableText(
            selected: selected == 0,
            label: 'Contact',
            onClick: () {
              setState(() {
                selected = 0;
              });
            },
          ),
          SpacerHorizontal(16),
          SelectableText(
            selected: selected == 1,
            label: 'Recent',
            onClick: () {
              setState(() {
                selected = 1;
              });
            },
          ),
          Spacer(),
          InkWell(
            child: SvgView(ImageFactory.ic_search, width: 30),
            onTap: () {
              setState(() {
                showSearchBar = true;
              });
            },
          ),
          SpacerHorizontal(24),
          SvgView(ImageFactory.ic_menu, width: 30),
          SpacerHorizontal(16),
        ],
      );
    }
  }
}
class SelectableText extends StatelessWidget {
  final String label;
  final VoidCallback onClick;
  final bool selected;

  const SelectableText({
    required this.selected,
    required this.label,
    required this.onClick,
  });

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
          if (selected)
            Container(
              width: double.infinity,
              height: 1.5,
              decoration: BoxDecoration(color: primary),
            ),
        ],
      ),
    );
  }
}
class _SearchBar extends StatefulWidget {
  final Function(String query) onQueryChanged;
  final VoidCallback onDismiss;

  const _SearchBar({
    super.key,
    required this.onQueryChanged,
    required this.onDismiss,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}
class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  var query = '';

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
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
          border: Border.all(color: Color(0xFFCBD5E1)),
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
                  hintStyle: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontFamily: ThemeFactory.theme.font,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _controller.text = '';
                if (query.isNotEmpty) {
                  setState(() {
                    query = '';
                  });
                }

                widget.onDismiss();
              },
              child: Icon(Icons.clear, color: Color(0xFF4B5563)),
            ),
            SpacerHorizontal(8),
          ],
        ),
      ),
    );
  }
}