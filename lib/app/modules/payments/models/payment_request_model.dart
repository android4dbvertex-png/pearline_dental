class PaymentRequestModel {
  final String id;
  final int amount;
  final String title;
  final String description;
  final String status;

  PaymentRequestModel({
    required this.id,
    required this.amount,
    required this.title,
    required this.description,
    required this.status,
  });

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      id: json['_id'] ?? '',
      amount: json['amount'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
    );
  }
}