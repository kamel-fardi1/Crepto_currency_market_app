import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'MyCurrency.dart';
import '../home/home.dart';
import '../product_details.dart';

class MyCurrencies extends StatefulWidget {
  const MyCurrencies({super.key});

  @override
  State<MyCurrencies> createState() => _MyCurrenciesState();
}

class _MyCurrenciesState extends State<MyCurrencies> {
  late SharedPreferences prefs;
  late Future<bool> fetchedCurrencies;
  final List<MyCurrency> myCurrencies = [];
  late User user = User();
  final String _baseUrl = "10.0.2.2:9090";
  Future<bool> fetchMyCurrencies() async {
    prefs = await SharedPreferences.getInstance();

    user = User(
      userId: prefs.getString("userId"),
      username: prefs.getString("username"),
      identifier: prefs.getString("identifier"),
      balance: prefs.getDouble("balance"),
    );
    final http.Response response = await http.get(
      Uri.http(_baseUrl, "/api/currencies/liste/${user.userId}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      //final List<dynamic> currencies = jsonDecode(response.body);
      List<dynamic> currencies = json.decode(response.body);
      //print(response.body);
      for (var mycurrency in currencies) {
        myCurrencies.add(MyCurrency(
            currency: Currency(
                image: mycurrency["currency"]["image"],
                name: mycurrency["currency"]["name"],
                id: mycurrency["currency"]["_id"],
                description: mycurrency["currency"]["description"],
                code: mycurrency["currency"]["code"],
                unitPrice: double.parse(
                    mycurrency["currency"]["unitPrice"].toString())), //
            quantity: int.parse(mycurrency["quantity"].toString()),
            id: mycurrency["_id"]));
      }
      print(myCurrencies.length);
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    fetchedCurrencies = fetchMyCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Currencies"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchedCurrencies,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      '${myCurrencies.length} Different coins',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: myCurrencies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MyCurrencyInfo(
                            myCurrencies[index].currency!.image!,
                            "${myCurrencies[index].quantity} ${myCurrencies[index].currency!.code!}");
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 120,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5),
                    ),
                  ),
                ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MyCurrency {
  final Currency? currency;
  final int? quantity;
  final String? id;

  MyCurrency({
    required this.currency,
    required this.quantity,
    required this.id,
  });
}
