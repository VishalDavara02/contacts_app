import 'package:equatable/equatable.dart';

class Contact extends Equatable{
  final String name;
  final String phone;
  final String email;

  const Contact({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => {
        'name': name,
        'phone': phone,
        'email': email,
      }.toString();

@override
  List<Object?> get props => [name,  phone, email];

}
