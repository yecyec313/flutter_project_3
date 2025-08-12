import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bage extends StatelessWidget {
  final int repos;
  const Bage({super.key, required this.repos});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: repos > 0,
        child: Container(
          alignment: Alignment.center,
          width: 18,
          height: 18,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary),
          child: Text(
            repos.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
