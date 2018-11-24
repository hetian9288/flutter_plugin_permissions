import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_permissions/flutter_plugin_permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Plugin example app'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      FlutterPluginPermissions().openAppSettings();
                    },
                  )
                ],
              ),
              body: Center(
                child: ListView(
                        children: PermissionGroup.values
                                .where((PermissionGroup permission) {
                          if (Platform.isIOS) {
                            return permission != PermissionGroup.unknown &&
                                    permission != PermissionGroup.phone &&
                                    permission != PermissionGroup.sms &&
                                    permission != PermissionGroup.storage;
                          } else {
                            return permission != PermissionGroup.unknown &&
                                    permission != PermissionGroup.mediaLibrary &&
                                    permission != PermissionGroup.photos &&
                                    permission != PermissionGroup.reminders;
                          }
                        })
                                .map((PermissionGroup permission) =>
                                PermissionWidget(permission))
                                .toList()),
              ),
            ));
  }
}

class PermissionWidget extends StatefulWidget {
  const PermissionWidget(this._permissionGroup);

  final PermissionGroup _permissionGroup;

  @override
  _PermissionState createState() => _PermissionState(_permissionGroup);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permissionGroup);

  final PermissionGroup _permissionGroup;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() {
    final Future<PermissionStatus> statusFuture =
    FlutterPluginPermissions().checkPermissionStatus(_permissionGroup);

    statusFuture.then((PermissionStatus status) {
      setState(() {
        _permissionStatus = status;
      });
    });
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_permissionGroup.toString()),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      onTap: () async {
        requestPermission(_permissionGroup);
      },
    );
  }

  void requestPermission(PermissionGroup permission) {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Future<Map<PermissionGroup, PermissionStatus>> requestFuture =
    FlutterPluginPermissions().requestPermissions(permissions);

    requestFuture
            .then((Map<PermissionGroup, PermissionStatus> permissionRequestResult) {
      setState(() {
        _permissionStatus = permissionRequestResult[permission];
      });
    });
  }
}
