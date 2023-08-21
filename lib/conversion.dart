import 'network.dart';

const Server = 'https://rest.coinapi.io/v1';
const apiKey = '/APIKEY-C946DDFC-61DA-4C6F-8EAA-CA9C9FC85A45';

class Conversion {
  late String curr;
  late String crypto;

  Future<dynamic> getDataCryptoCurrency(String curr, String crypto) async {
    var url = '$Server$apiKey/exchangerate/$crypto/$curr';
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    return data;
  }
}
