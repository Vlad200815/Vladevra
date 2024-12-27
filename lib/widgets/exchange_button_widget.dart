import 'package:flutter/material.dart';

class ExchangeButton extends StatelessWidget {
  const ExchangeButton({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 5,
          ),
        ),
        child: Icon(
          Icons.currency_exchange_outlined,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
