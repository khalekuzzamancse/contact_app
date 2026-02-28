import 'package:contact_app/core/ui/core_ui.dart';
import 'package:flutter/material.dart';

import '../_core/core_ui.dart';

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
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            SpacerVertical(24),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldView(hintText: 'Name', controller: nameController),
                  PhoneNumberPicker(
                      onCountryCodeChanged: (_ ) {  },
                      onNumberChanged: (_ ) {  },
                    onFullNumberChanged: (_ ) {  },),
                  TextFieldView(hintText: 'Designation', controller: designationController),
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
      ),
    );
  }
}
void showBottomSheet(BuildContext context){
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