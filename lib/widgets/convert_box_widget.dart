import 'package:flutter/material.dart';

class ConvertBox extends StatelessWidget {
  const ConvertBox({
    super.key,
    required this.countryName,
    required this.price,
    required this.countryNick,
    required this.flagImage,
    required this.controller,
    required this.onSubmitted,
    required this.readOnly,
  });

  final String countryName;
  final double price;
  final String countryNick;
  final String flagImage;
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 20, 20, 20),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    countryName,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      readOnly: readOnly,
                      onSubmitted: onSubmitted,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      controller: controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "0.00",
                        border: InputBorder.none, // Removes the underline
                        hintStyle: TextStyle(color: Colors.grey),
                        isDense: true, // Optional: to reduce vertical padding
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 30,
                  child: Image.asset(flagImage),
                ),
                const SizedBox(width: 5),
                Text(
                  countryNick,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
