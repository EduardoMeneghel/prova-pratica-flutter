import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ApiService {
  static ApiService? _instance;
  final String apiKey = 'c513ad3a';

  factory ApiService() {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance!;
  }

  ApiService._internal();

  Map<String, dynamic>? _cachedData;

  Future<Map<String, dynamic>?> fetchData() async {
    if (_cachedData != null) {
      return _cachedData;
    }

    final response = await http.get(
      Uri.parse(
          'https://api.hgbrasil.com/finance?key=$apiKey&format=json-cors'),
    );

    if (response.statusCode == 200) {
      _cachedData = json.decode(response.body);
      return _cachedData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/moedas",
    routes: {
      "/moedas": (context) => Moedas(),
      "/acoes": (context) => Acoes(),
      "/bitcoin": (context) => Bitcoin(),
    },
  ));
}

class Moedas extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanças de Hoje'),
        backgroundColor: Colors.green[900],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: apiService.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<String, dynamic>? data = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('Moedas', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoMoeda(
                            'Dólar',
                            data?['results']['currencies']['USD'],
                          ),
                          buildInfoMoeda(
                            'Euro',
                            data?['results']['currencies']['EUR'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoMoeda(
                            'Peso',
                            data?['results']['currencies']['ARS'],
                          ),
                          buildInfoMoeda(
                            'Yen',
                            data?['results']['currencies']['JPY'],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/acoes");
                  },
                  child: Text('Ir para Ações'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildInfoMoeda(
      String currencyName, Map<String, dynamic>? currencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currencyName,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              '${currencyData?['buy'].toStringAsFixed(4)}',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    currencyData?['variation'] < 0 ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currencyData?['variation'].toStringAsFixed(4)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Acoes extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanças de Hoje'),
        backgroundColor: Colors.green[900],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: apiService.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<String, dynamic>? data = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('Ações', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoAcoes(
                            'IBOVESPA',
                            data?['results']['stocks']['IBOVESPA'],
                          ),
                          buildInfoAcoes(
                            'IFIX',
                            data?['results']['stocks']['IFIX'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoAcoes(
                            'NASDAQ',
                            data?['results']['stocks']['NASDAQ'],
                          ),
                          buildInfoAcoes(
                            'DOWJONES',
                            data?['results']['stocks']['DOWJONES'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoAcoes(
                            'CAC',
                            data?['results']['stocks']['CAC'],
                          ),
                          buildInfoAcoes(
                            'NIKKEI',
                            data?['results']['stocks']['NIKKEI'],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/bitcoin");
                  },
                  child: Text('Ir para Bitcoin'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildInfoAcoes(
      String currencyName, Map<String, dynamic>? currencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currencyName,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              '${currencyData?['points'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    currencyData?['variation'] < 0 ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currencyData?['variation'].toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Bitcoin extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanças de Hoje'),
        backgroundColor: Colors.green[900],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: apiService.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<String, dynamic>? data = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('BitCoin', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoBitcoin(
                            'Blockchain.info',
                            data?['results']['bitcoin']['blockchain_info'],
                          ),
                          buildInfoBitcoin(
                            'Coinbase',
                            data?['results']['bitcoin']['coinbase'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoBitcoin(
                            'bitstamp',
                            data?['results']['bitcoin']['bitstamp'],
                          ),
                          buildInfoBitcoin(
                            'foxbit',
                            data?['results']['bitcoin']['foxbit'],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoBitcoin(
                            'mercadobitcoin',
                            data?['results']['bitcoin']['mercadobitcoin'],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/moedas");
                  },
                  child: Text('Página Principal'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[900],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildInfoBitcoin(
      String currencyName, Map<String, dynamic>? currencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currencyName,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              '${currencyData?['last'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    currencyData?['variation'] < 0 ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currencyData?['variation'].toStringAsFixed(3)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
