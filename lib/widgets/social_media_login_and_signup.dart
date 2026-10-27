import 'package:flutter/material.dart';

class SocialMediaLoginAndSignup extends StatelessWidget {
  const SocialMediaLoginAndSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: (){}, icon: Icon(Icons.import_contacts)),
        IconButton(onPressed: (){}, icon: Icon(Icons.facebook)),
        IconButton(onPressed: (){}, icon: Icon(Icons.apple)),
      ],
    );
  }
}