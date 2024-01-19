// import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final statusLoading = ref.watch(statusLoadingProvider);
  return statusLoading;
});
