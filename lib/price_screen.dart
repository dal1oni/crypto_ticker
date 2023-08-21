import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'conversion.dart';
import 'exchange_widget.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String selectedCryptoCurrency = 'BTC';
  String url =
      'https://rest.coinapi.io/v1/APIKEY-C946DDFC-61DA-4C6F-8EAA-CA9C9FC85A45/exchangerate/BTC/USD';

  Conversion conversion = Conversion();
  dynamic courseBTC = '?';
  dynamic courseETH = '?';
  dynamic courseLTC = '?';

  void updateUI(
      dynamic courseDataBTC, dynamic courseDataETH, dynamic courseDataLTC) {
    selectedCurrency = courseDataBTC['asset_id_quote'];
    courseBTC = courseDataBTC['rate'].round();
    courseETH = courseDataETH['rate'].round();
    courseLTC = courseDataLTC['rate'].round();
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else {
      return androidButton();
    }
  }

  DropdownButton<String> androidButton() {
    List<DropdownMenuItem<String>> items = [];
    for (String curr in currenciesList) {
      items.add(
        DropdownMenuItem(
          child: Text(curr),
          value: curr,
        ),
      );
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
        print(value);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> items = [];
    for (String cur in currenciesList) {
      items.add(Text(cur));
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) async {
        var courseDataBTC = await conversion.getDataCryptoCurrency(
            currenciesList[selectedIndex], 'BTC');
        var courseDataETH = await conversion.getDataCryptoCurrency(
            currenciesList[selectedIndex], 'ETH');
        var courseDataLTC = await conversion.getDataCryptoCurrency(
            currenciesList[selectedIndex], 'LTC');
        setState(() {
          updateUI(courseDataBTC, courseDataETH, courseDataLTC);
        });
      },
      children: items,
    );
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              exchangeWidget(
                  crypto: 'BTC', currency: selectedCurrency, course: courseBTC),
              exchangeWidget(
                  crypto: 'ETH', currency: selectedCurrency, course: courseETH),
              exchangeWidget(
                  crypto: 'LTC', currency: selectedCurrency, course: courseLTC),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidButton(),
          ),
        ],
      ),
    );
  }
}
