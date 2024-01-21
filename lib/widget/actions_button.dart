import 'package:flutter/material.dart';

class Actionsbutton extends StatelessWidget {
  final void Function() onPressed;
  const Actionsbutton({
    super.key, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF325E8C), 
      shape: const CircleBorder(), 
      child: const Icon(
        Icons.add,
        size: 25,
        color: Colors.white, 
      ),
    );
  }
}