import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_application/real_time_line_chart.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _bluetooth = FlutterBluetoothSerial.instance;
  final bool _bluetoothState = false;
  bool _isConnecting = false;
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _deviceConnected;
  String times = '0';

  void _getDevices() async {
    var res = await _bluetooth.getBondedDevices();
    setState(() => _devices = res);
  }

  void _receiveData() {
    const splitter = LineSplitter();
    // _connection?.input?.listen((Uint8List data) {
    //   // debugPrint('Data incoming: ${ascii.decode(data)} + ${data.length}');
    //   int value = 0;
    //   if (data.length == 2) {
    //     value =
    //         (data[0] << 8) + data[1]; // Combine two bytes into a uint16 value
    //     debugPrint('SIII');
    //   } else {
    //     value = int.parse(ascii.decode(data));
    //   }
    //   // debugPrint('Data incoming: $value');
    //   setState(() => times = value.toString());
    //   // debugPrint("  ");
    //   // print(event);
    // });
    _connection?.input?.listen((Uint8List data) {
      if (data.length > 2) {
        debugPrint('raw data: $data');
        debugPrint('ascii data: ${ascii.decode(data)}');
        debugPrint('String data: ${String.fromCharCodes(data)}');
        var stringList = splitter.convert(String.fromCharCodes(data));
        debugPrint(
            'Splitter string data: $stringList');
        var largestVal = int.parse(stringList[0]);
        for (var i = 0; i < stringList.length ; i++) {
          var stringListInt = int.parse(stringList[i]);
          if (stringListInt > largestVal) {
            largestVal = stringListInt;
          }
        }
        debugPrint('Unique value: $largestVal');
        debugPrint('------------------------------------------------');
        setState(() =>
            times = largestVal.toString());
      }
      // setState(() => times = ascii.decode(data));
    });
  }

  void _sendData(String data) {
    if (_connection?.isConnected ?? false) {
      _connection?.output.add(ascii.encode(data));
    }
  }

  void _requestPermission() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  @override
  void initState() {
    super.initState();

    _requestPermission();

    // _bluetooth.state.then((state) {
    //   setState(() => _bluetoothState = state.isEnabled);
    // });

    // _bluetooth.onStateChanged().listen((state) {
    //   switch (state) {
    //     case BluetoothState.STATE_OFF:
    //       setState(() => _bluetoothState = false);
    //       break;
    //     case BluetoothState.STATE_ON:
    //       setState(() => _bluetoothState = true);
    //       break;
    //     // case BluetoothState.STATE_TURNING_OFF:
    //     //   break;
    //     // case BluetoothState.STATE_TURNING_ON:
    //     //   break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter and Arduino'),
      ),
      body: Column(
        children: [
          _infoDevice(),
          Expanded(child: _listDevices()),
          _inputSerial(),
          LiveLineChart(times),
          // _buttons(),
        ],
      ),
    );
  }

  Widget _controlBT() {
    return SwitchListTile(
      value: _bluetoothState,
      onChanged: (bool value) async {
        if (value) {
          await _bluetooth.requestEnable();
        } else {
          await _bluetooth.requestDisable();
        }
      },
      tileColor: Colors.black26,
      title: Text(
        _bluetoothState ? "Bluetooth encendido" : "Bluetooth apagado",
      ),
    );
  }

  Widget _infoDevice() {
    return ListTile(
      tileColor: Colors.black12,
      title: Text("Conectado a: ${_deviceConnected?.name ?? "ninguno"}"),
      trailing: _connection?.isConnected ?? false
          ? TextButton(
              onPressed: () async {
                await _connection?.finish();
                setState(() => _deviceConnected = null);
              },
              child: const Text("Desconectar"),
            )
          : TextButton(
              onPressed: _getDevices,
              child: const Text("Ver dispositivos"),
            ),
    );
  }

  Widget _listDevices() {
    return _isConnecting
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  ...[
                    for (final device in _devices)
                      ListTile(
                        title: Text(device.name ?? device.address),
                        trailing: TextButton(
                          child: const Text('conectar'),
                          onPressed: () async {
                            setState(() => _isConnecting = true);

                            _connection = await BluetoothConnection.toAddress(
                                device.address);
                            _deviceConnected = device;
                            _devices = [];
                            _isConnecting = false;

                            _receiveData();

                            setState(() {});
                          },
                        ),
                      )
                  ]
                ],
              ),
            ),
          );
  }

  Widget _inputSerial() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -3),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          "Valor = $times",
          style: const TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
