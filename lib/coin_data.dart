import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<double> getCoinData(String coinCurrency, String fiatCurrency) async {
    http.Response response = await http.get(
      Uri.parse(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/$coinCurrency$fiatCurrency',
      ),
      headers: {'x-ba-key': 'MTFiZDRlOTJhMTE5NDdhZTgyNTViZTc5MGE4NGI2MTA'},
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData['last'];
    } else {
      print('${response.statusCode} - ${response.body}');
      throw 'Problem contacting API';
    }
  }
}
