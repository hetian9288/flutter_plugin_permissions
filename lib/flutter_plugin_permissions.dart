library permission_handler;
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

part 'package:flutter_plugin_permissions/permission_enums.dart';
part 'package:flutter_plugin_permissions/utils/codec.dart';

class FlutterPluginPermissions {

  factory FlutterPluginPermissions() {
    if (_instance == null) {
      const MethodChannel methodChannel =
      MethodChannel('flutter_plugin_permissions');

      _instance = FlutterPluginPermissions.private(methodChannel);
    }
    return _instance;
  }

  @visibleForTesting
  FlutterPluginPermissions.private(this._methodChannel);

  static FlutterPluginPermissions _instance;

  final MethodChannel _methodChannel;

  /// Returns a [Future] containing the current permission status for the supplied [PermissionGroup].
  Future<PermissionStatus> checkPermissionStatus(
          PermissionGroup permission) async {
    final dynamic status = await _methodChannel.invokeMethod(
            'checkPermissionStatus', Codec.encodePermissionGroup(permission));

    return Codec.decodePermissionStatus(status);
  }

  /// Open the App settings page.
  ///
  /// Returns [true] if the app settings page could be opened, otherwise [false] is returned.
  Future<bool> openAppSettings() async {
    final bool hasOpened = await _methodChannel.invokeMethod('openAppSettings');
    return hasOpened;
  }

  /// Request the user for access to the supplied list of permissiongroups.
  ///
  /// Returns a [Map] containing the status per requested permissiongroup.
  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions(
          List<PermissionGroup> permissions) async {
    final String jsonData = Codec.encodePermissionGroups(permissions);
    final dynamic status =
    await _methodChannel.invokeMethod('requestPermissions', jsonData);
    return Codec.decodePermissionRequestResult(status);
  }

  /// Request to see if you should show a rationale for requesting permission.
  ///
  /// This method is only implemented on Android, calling this on iOS always
  /// returns [false].
  Future<bool> shouldShowRequestPermissionRationale(
          PermissionGroup permission) async {
    if (!Platform.isAndroid) {
      return false;
    }

    final bool shouldShowRationale = await _methodChannel.invokeMethod(
            'shouldShowRequestPermissionRationale',
            Codec.encodePermissionGroup(permission));

    return shouldShowRationale;
  }
}
