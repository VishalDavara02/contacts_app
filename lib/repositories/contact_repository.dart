import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContacts();
}

class ContactRepositoryImpl implements ContactRepository {
  @override
  Future<List<Contact>> getContacts() async {
    final String response =
        await rootBundle.loadString('assets/mock_data.json');
    final data =
        (jsonDecode(response)['contacts'] as List).map((e) => e as Map);
    return data
        .map((json) => Contact.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
