import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedContactsProvider = StateProvider<List<Contact>>((ref) => []);