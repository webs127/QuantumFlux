import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

import 'package:http/http.dart' as http;
import 'package:quantumkey/model/quantumvalue_model.dart';

class ApiService {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? "";
  //final String _apiKey = dotenv.env['API_KEY'] ?? "";

  Future<QuantumValue> getQuantumValues(double length, String type) async {
    final url = Uri.parse('$_baseUrl?length=$length&type=$type');
    final response = await http.get(url,
    headers: {
      'Content-type': "application/json"
    },
    );

    if(response.statusCode == 200) {
      print(response.body);
      final quantumValue = QuantumValue.fromJson(jsonDecode(response.body));
      return quantumValue;
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }


}