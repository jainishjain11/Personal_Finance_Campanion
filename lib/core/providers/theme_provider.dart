import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeState extends _$ThemeState {
  late Box _box;

  @override
  ThemeMode build() {
    _box = Hive.box('settings');
    final savedMode = _box.get('themeMode', defaultValue: 'system') as String;
    return ThemeMode.values.firstWhere(
      (e) => e.name == savedMode,
      orElse: () => ThemeMode.system,
    );
  }

  void setTheme(ThemeMode mode) {
    _box.put('themeMode', mode.name);
    state = mode;
  }
}
