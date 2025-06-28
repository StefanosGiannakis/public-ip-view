import 'dart:async';
import 'package:flutter/services.dart';

class HomeWidget {
  static const MethodChannel _channel = MethodChannel('home_widget');

  static Future<void> saveWidgetData<T>(String id, T data) async {
    await _channel.invokeMethod('saveWidgetData', {
      'id': id,
      'data': data,
    });
  }

  static Future<T?> getWidgetData<T>(String id) async {
    final data = await _channel.invokeMethod('getWidgetData', {
      'id': id,
    });
    return data as T?;
  }

  static Future<void> updateWidget({
    String? name,
    String? androidName,
    String? iOSName,
    Map<String, dynamic>? qualifiedAndroidName,
  }) async {
    await _channel.invokeMethod('updateWidget', {
      'name': name,
      'android': androidName,
      'ios': iOSName,
      'qualifiedAndroidName': qualifiedAndroidName,
    });
  }

  static Future<void> registerBackgroundCallback(
      Future<void> Function(Uri?) callback) async {
    await _channel.invokeMethod('registerBackgroundCallback');
  }

  static Future<void> setAppGroupId(String groupId) async {
    await _channel.invokeMethod('setAppGroupId', {
      'groupId': groupId,
    });
  }
}
