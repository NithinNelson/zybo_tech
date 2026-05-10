import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final double amount;
  final String note;
  final String type;
  final String categoryId;
  final String? categoryName;
  final DateTime timestamp;
  final bool isSynced;
  final bool isDeleted;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
    this.categoryName,
    required this.timestamp,
    this.isSynced = false,
    this.isDeleted = false,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      note: json['note'],
      type: json['type'],
      categoryId: json['category_id'] ?? json['category'] ?? '',
      categoryName: json['category_name'],
      timestamp: DateTime.parse(json['timestamp']),
      isSynced: json['is_synced'] == 1 || json['is_synced'] == true,
      isDeleted: json['is_deleted'] == 1 || json['is_deleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'type': type,
      'category_id': categoryId,
      'timestamp': timestamp.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }
  
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'type': type,
      'category_id': categoryId,
      'timestamp': timestamp.toIso8601String().replaceAll('T', ' ').substring(0, 19),
    };
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? note,
    String? type,
    String? categoryId,
    String? categoryName,
    DateTime? timestamp,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        note,
        type,
        categoryId,
        categoryName,
        timestamp,
        isSynced,
        isDeleted,
      ];
}
