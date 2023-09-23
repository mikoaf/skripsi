import 'dart:async';

import 'package:aplikasi_ekg/bth/BluetoothDeviceListEntry.dart';
import 'package:aplikasi_ekg/pages/bth_before.dart';
import 'package:aplikasi_ekg/pages/home_page.dart';
import 'package:aplikasi_ekg/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class bth_after extends StatefulWidget {
  const bth_after({super.key});

  @override
  State<bth_after> createState() => _bth_afterState();
}

class _bth_afterState extends State<bth_after> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> result =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _restartDiscovery() {
    setState(() {
      result.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = result.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          result[existingIndex] = r;
        else
          result.add(r);
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back_grey_col,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Home_Page()),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/back_pic.png'))),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Search results',
                    style: dark_blue_text_sty.copyWith(
                        fontSize: 30, fontWeight: medium),
                  ),
                  const Spacer(),
                  Container(
                    width: 80,
                    height: 40,
                  ),
                ],
              ),
              Container(
                width: 350,
                height: 350,
                child: ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (BuildContext context, index) {
                      BluetoothDiscoveryResult results = result[index];
                      final device = results.device;
                      final address = device.address;
                      return BluetoothDeviceListEntry(
                        device: device,
                        rssi: results.rssi,
                        onTap: () {
                          Navigator.of(context).pop(results.device);
                        },
                        onLongPress: () async {
                          try {
                            bool bonded = false;
                            if (device.isBonded) {
                              print('Unbonding from ${device.address}...');
                              await FlutterBluetoothSerial.instance
                                  .removeDeviceBondWithAddress(address);
                              print(
                                  'Bonding with ${device.address} has succeed');
                            } else {
                              print('Bonding with ${device.address}...');
                              bonded = (await FlutterBluetoothSerial.instance
                                  .bondDeviceAtAddress(address))!;
                              print(
                                  'Bonding with ${device.address} has ${bonded ? 'succeed' : 'failed'}.');
                            }
                            setState(() {
                              result[result.indexOf(results)] =
                                  BluetoothDiscoveryResult(
                                      device: BluetoothDevice(
                                        name: device.name ?? '',
                                        address: address,
                                        type: device.type,
                                        bondState: bonded
                                            ? BluetoothBondState.bonded
                                            : BluetoothBondState.none,
                                      ),
                                      rssi: results.rssi);
                            });
                          } catch (ex) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Error occured while bonding'),
                                    content: Text("${ex.toString()}"),
                                    actions: <Widget>[
                                      new TextButton(
                                        child: new Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                      );
                    }),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const bth_before()));
                      },
                      child: Text(
                        'New Search',
                        style: grey_text_sty.copyWith(
                            fontSize: 25, fontWeight: regular),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
