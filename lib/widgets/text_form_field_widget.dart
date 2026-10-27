import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.hint,
    this.onChanged,
    this.icon,
    this.obscureText = false,
    this.onIconPressed,
    this.validator,
  });

  final String hint;
  final Function(String)? onChanged;
  final Widget? icon; 
  final bool obscureText;
  final VoidCallback? onIconPressed;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: icon != null
              ? IconButton(
                  onPressed: onIconPressed,
                  icon: icon!,
                )
              : null,
          suffixIconColor: Colors.white,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}