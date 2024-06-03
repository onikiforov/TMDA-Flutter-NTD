import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmda/app.dart';
import 'package:tmda/bloc_observer.dart';
import 'package:tmda/injection_container.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'package:native_flutter_proxy/custom_proxy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  String? host;
  int? port;
  ProxySetting settings = await NativeProxyReader.proxySetting;
  host = settings.host;
  port = settings.port;
  if (host != null && port != null) {
    final proxy = CustomProxy(ipAddress: host, port: port);
    proxy.enable();
  }
  configureDependencies(); 
  Bloc.observer = MyBlocObserver();
  runApp(const TmdaApp());
}