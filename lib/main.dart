import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:home_widget/home_widget.dart';
import 'dart:async';
import 'dart:io';

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'updateip') {
    await _fetchIpAndUpdateWidget();
  }
}

Future<String?> _fetchIpAndUpdateWidget() async {
  try {
    final response = await http.get(Uri.parse('https://api.ipify.org'));

    if (response.statusCode == 200) {
      final ip = response.body;

      await HomeWidget.saveWidgetData<String>('ip_address', ip);

      await HomeWidget.updateWidget(
        name: 'HomeWidgetProvider',
        androidName: 'HomeWidgetProvider',
        iOSName: 'PublicIPWidget',
      );

      return ip;
    }
  } catch (e) {
    debugPrint('Error fetching IP: $e');
  }
  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HomeWidget.registerBackgroundCallback(backgroundCallback);

  if (Platform.isAndroid) {
    await HomeWidget.setAppGroupId('com.example.public_ip_view');
  } else if (Platform.isIOS) {
    await HomeWidget.setAppGroupId('group.com.example.publicIpView');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Public IP Viewer',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.blueGrey,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const MyHomePage(title: 'Public IP Viewer'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ipAddress = 'No IP fetched yet';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();

    Timer.periodic(const Duration(minutes: 5), (timer) async {
      await _updateIpAddress();
    });
  }

  Future<void> _loadInitialData() async {
    final savedIp = await HomeWidget.getWidgetData<String>('ip_address');
    if (savedIp != null) {
      setState(() {
        _ipAddress = savedIp;
      });
    } else {
      await _updateIpAddress();
    }
  }

  Future<void> _updateIpAddress() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final ip = await _fetchIpAndUpdateWidget();

    setState(() {
      if (ip != null) {
        _ipAddress = ip;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title,
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your current public IP address:',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _ipAddress,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateIpAddress,
              child: const Text('Refresh Widget',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'The home screen widget will refresh automatically every 5 minutes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
