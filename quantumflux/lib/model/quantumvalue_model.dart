
// {
//     "type": "uint8",
//     "length": 16,
//     "data": [
//         125,
//         25,
//         12,
//         10,
//         117,
//         247,
//         107,
//         63,
//         227,
//         60,
//         111,
//         250,
//         187,
//         163,
//         144,
//         144
//     ],
//     "success": true
// }

class QuantumValue {
  final String type;
  final List<dynamic> data;
  final int length;
  final bool success;

  QuantumValue({
    required this.type,
    required this.data,
    required this.length,
    required this.success,
  });

  factory QuantumValue.fromJson(Map<String, dynamic> json) => QuantumValue(
    type: json['type'],
    data: json['data'],
    length: json['length'],
    success: json['success'],
  );
}
