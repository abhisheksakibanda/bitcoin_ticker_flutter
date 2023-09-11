import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = currenciesList[0];
  Map<String, String> coinPrices = {
    'BTC': '?',
    'ETH': '?',
    'LTC': '?',
  };

  DropdownButton<String> androidDropdown() {
    return DropdownButton<String>(
      items: currenciesList
          .map(
            (currency) => DropdownMenuItem(
              child: Text(currency),
              value: currency,
            ),
          )
          .toList(),
      onChanged: (currency) async {
        setPrices(currency!);
      },
      value: selectedCurrency,
    );
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        String fiatCurrency = currenciesList[selectedIndex];
        setPrices(fiatCurrency);
      },
      children: currenciesList.map((currency) => Text(currency)).toList(),
    );
  }

  Future<void> setPrices(String currency) async {
    for (String cryptoCoin in cryptoList) {
      double coinPrice = await coinData.getCoinData(cryptoCoin, currency);
      coinPrices[cryptoCoin] = coinPrice.toStringAsFixed(2);
    }
    setState(() {
      selectedCurrency = currency;
    });
  }

  @override
  void initState() {
    super.initState();
    setPrices(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: coinPriceWidgets(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

  List<Card> coinPriceWidgets() {
    List<Card> priceCards = [];
    for (String cryptoCoin in cryptoList) {
      Card priceCard = Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCoin = ${coinPrices[cryptoCoin]} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );
      priceCards.add(priceCard);
    }
    return priceCards;
  }
}
