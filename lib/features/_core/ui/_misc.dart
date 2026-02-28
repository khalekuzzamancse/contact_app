part of '../core_ui.dart';
class PhoneNumberPicker extends StatelessWidget {
  final Function(String) onCountryCodeChanged,onNumberChanged,onFullNumberChanged;

  const PhoneNumberPicker({
    super.key,
    required this.onCountryCodeChanged,  required this.onNumberChanged, required this.onFullNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
          dropdownIconPosition:  IconPosition.trailing,
          flagsButtonPadding: const EdgeInsets.only(left: 8),
          showCountryFlag: true,
          disableLengthCheck: true,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            hintStyle: TextStyle(
              fontFamily: ThemeFactory.theme.font,
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: _enableBorder,
            enabledBorder: _enableBorder,
            focusedBorder: _focusedBorder,
          ),
          initialCountryCode: 'BD',
          onChanged: (phone) {
            onNumberChanged(phone.number);
            onCountryCodeChanged(phone.countryCode);
            onFullNumberChanged(phone.completeNumber);
          },
        ),
      ],
    );
  }
}
final _enableBorder=OutlineInputBorder(
  borderSide:  BorderSide(color:Color(0xFFCBD5E1)),
);
final _focusedBorder=OutlineInputBorder(
  borderSide:  BorderSide(color:ThemeFactory.theme.colorPrimary),
);
class TextFieldView extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType inputType;

  const TextFieldView({super.key,
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
        style:TextStyle(
            fontFamily: ThemeFactory.theme.font
        ) ,
        decoration: InputDecoration(
          hintText: hintText,
            border: _enableBorder,
            enabledBorder: _enableBorder,
            focusedBorder: _focusedBorder,
          hintStyle: TextStyle(
            fontFamily: ThemeFactory.theme.font,
          )
        ),
      ),
    );
  }
}

class DropdownView extends StatelessWidget {
  final String hintText;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownView({
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
        icon: Icon(Icons.keyboard_arrow_down_sharp),
        decoration: InputDecoration(
            hintText: hintText,
            border: _enableBorder,
            enabledBorder: _enableBorder,
            focusedBorder: _focusedBorder,
            hintStyle: TextStyle(
              fontFamily: ThemeFactory.theme.font
            )
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item,style:  TextStyle(
              fontFamily: ThemeFactory.theme.font
          )),
        ))
            .toList(),
      ),
    );
  }
}

final gradientDecorator = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFECFBF7),
      Colors.white,
    ],
  ),
);
class ButtonView extends StatelessWidget {
  final String label;
  final Color background, forground;
  final Color? borderColor,labelColor;
  final double width;
  final VoidCallback onPressed;
  const ButtonView({super.key, required this.label, required this.background,
    required this.forground,this.width=double.infinity,required this.onPressed, this.borderColor, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: forground
          , backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side:borderColor==null?BorderSide.none: BorderSide(
                color: borderColor!,width: 1.5),
          ),
        ),
        child: TextView(label,fontSize: 16,fontWeight: FontWeight.w600,color: labelColor),
      ),
    );
  }
}
