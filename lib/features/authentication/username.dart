import 'package:flutter/material.dart';

class Fname extends StatefulWidget {
  const Fname(
      {super.key,
      required this.width,
      required this.buttonClicked,
      required this.itemHeight});

  final double width;
  final double itemHeight;
  final bool buttonClicked;

  @override
  State<Fname> createState() {
    return _Fname();
  }
}

class _Fname extends State<Fname> {
  @override
  Widget build(buildContext) {
    //User Authentication
    var username = TextEditingController();
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: super.widget.width,
          height: super.widget.itemHeight * 0.275,
          child: (super.widget.buttonClicked)
              ? const Text(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  'Name नाव',
                )
              : const SizedBox(),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: super.widget.width,
          height: super.widget.itemHeight * 0.75,
          child: (super.widget.buttonClicked)
              ? TextField(
                  controller: username,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'उदाहरण: Nana Patekar '),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
