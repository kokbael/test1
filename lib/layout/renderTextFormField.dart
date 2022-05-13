import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget renderTextFormField({
  @required String? label,
  @required FormFieldSetter? onSaved,
  @required FormFieldValidator? validator,
  @required TextEditingController? controller,
  @required int? minLines,
  @required FocusNode? focusNode,
  @required TextInputAction? textInputAction,
  @required bool? enabled,
  @required hintText,
}) {
  assert(onSaved != null);
  // assert(validator != null);
  assert(minLines != 0);
  return Column(
    children: [
      Row(
        children: [
          Text(
            label!,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      TextFormField(
        enabled: enabled,
        focusNode: focusNode,
        controller: controller,
        onSaved: onSaved,
        validator: validator,
        minLines: minLines,
        textInputAction: textInputAction,
        maxLines: null,
        autofocus: false,
        keyboardType: label == '비용' ? TextInputType.number : null,
        inputFormatters: label == '비용'
            ? <TextInputFormatter>[
                CurrencyTextInputFormatter(symbol: '', locale: 'ko'),
              ]
            : null,
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          contentPadding: EdgeInsets.all(20),
          hintStyle: TextStyle(fontSize: 12),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              // style: BorderStyle.solid,
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
      ),
      Container(height: 16.0),
    ],
  );
}
