import "dart:convert";

import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:http/http.dart" as http;
import "package:vladevra/widgets/convert_box_widget.dart";

class MyData {
  final String result;
  final String baseCode;
  final int remaining;
  final Map<String, dynamic> conversionRates;

  MyData({
    required this.result,
    required this.baseCode,
    required this.remaining,
    required this.conversionRates,
  });

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      result: json['result'],
      baseCode: json['base_code'],
      remaining: json['remaining'],
      conversionRates: json['conversion_rates'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController firstContr = TextEditingController();
  final TextEditingController secondContr = TextEditingController();
  String city = "Unknown...";
  int chooseIndex = 0;

  int bottomBarIndex = 0;
  List<dynamic> data = [];
  MyData myData =
      MyData(result: "", baseCode: "UAH", remaining: 0, conversionRates: {});

  @override
  void initState() {
    super.initState();
    _loadData();
    _getCity();
  }

  Future<void> _getCity() async {
    Position position = await _determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

    if (mounted) {
      setState(() {
        city = place.locality!;
      });
    }

    print("--------------------------------" + city);
    print(place.subAdministrativeArea);
    city = city + ", " + place.subAdministrativeArea!;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _loadData() async {
    final fetchedData = await _fetchData();
    final fetchedBiggerData = await _fetchBiggerData();
    if (mounted) {
      setState(() {
        data = fetchedData;
        myData = fetchedBiggerData;
        data.addAll([
          {
            "ccy": "PLN",
            "sale": ((myData.conversionRates["PLN"] * 100) + 0.20).toString(),
            "buy": (myData.conversionRates["PLN"] * 100).toString(),
          }
        ]);
      });
    }
  }

  Future<List<dynamic>> _fetchData() async {
    final apiUrl =
        'https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=5';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception("Something went wrong...");
    }
  }

  Future<MyData> _fetchBiggerData() async {
    final apiUrl =
        "https://api.currencyexchangerate-api.com/v1/97f495d9-3e60-431e-8914-f02c56a6603f/latest/UAH";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      return MyData.fromJson(jsonData);
    } else {
      throw Exception("Something went wrong...");
    }
  }

  num convertMoney(num otherPrice, num ukrMoney) {
    return ukrMoney / otherPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await _determinePosition();
      //   },
      // ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        leading: SizedBox(
          width: 20,
          height: 200,
          child: Image.asset(
            "assets/money.png",
          ),
        ),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vladevra.UA",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              city,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 5),
              ConvertBox(
                readOnly: false,
                onSubmitted: (p0) {
                  if (p0 != "") {
                    final String usdPrice = data[chooseIndex]["buy"];
                    final num price = num.parse(usdPrice);
                    num ukrMoney = num.parse(p0);
                    num result = convertMoney(price, ukrMoney);
                    result = (result * 100).floor() / 100;
                    secondContr.text = result.toString();
                  }
                },
                controller: firstContr,
                flagImage: "assets/ukraine.png",
                countryNick: "UAH",
                countryName: "Україна",
                price: 0.00,
              ),
              ConvertBox(
                readOnly: true,
                onSubmitted: (p0) {},
                controller: secondContr,
                flagImage: chooseIndex == 0
                    ? "assets/europe.png"
                    : chooseIndex == 1
                        ? "assets/states.png"
                        : "assets/poland.png",
                countryNick: chooseIndex == 0
                    ? "EUR"
                    : chooseIndex == 1
                        ? "USD"
                        : "PLN",
                countryName: chooseIndex == 0
                    ? "Європа"
                    : chooseIndex == 1
                        ? "Cешеа"
                        : "Польша",
                price: 0.00,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: const Color.fromARGB(255, 20, 20, 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Валюта",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Купівля",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Продаж",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.green,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final String isoName = data[index]['ccy'];
                final String buyPrice = data[index]['buy'];
                final String salePrice = data[index]['sale'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      chooseIndex = index;
                    });
                    if (firstContr.text != "") {
                      final String usdPrice = data[chooseIndex]["buy"];
                      final num price = num.parse(usdPrice);
                      num ukrMoney = num.parse(firstContr.text);
                      num result = convertMoney(price, ukrMoney);
                      result = (result * 100).floor() / 100;
                      secondContr.text = result.toString();
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        color: index == chooseIndex
                            ? Colors.grey[800]
                            : const Color.fromARGB(255, 20, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                isoName == "EUR"
                                    ? SizedBox(
                                        height: 40,
                                        width: 50,
                                        child: Image.asset(
                                          "assets/europe.png",
                                        ),
                                      )
                                    : isoName == "USD"
                                        ? SizedBox(
                                            height: 40,
                                            width: 50,
                                            child: Image.asset(
                                              "assets/states.png",
                                            ),
                                          )
                                        : SizedBox(
                                            height: 40,
                                            width: 50,
                                            child: Image.asset(
                                              "assets/poland.png",
                                            ),
                                          ),
                                const SizedBox(width: 15),
                                Text(
                                  isoName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              ((double.parse(buyPrice) * 100).floor() / 100)
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              ((double.parse(salePrice) * 100).floor() / 100)
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 5,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
