// import 'dart:ffi';
import 'dart:typed_data';

import 'package:aplikasi_ekg/model.dart';
import 'package:aplikasi_ekg/bth/ChatPage.dart';
import 'package:aplikasi_ekg/pages/bth_after.dart';
// import 'package:aplikasi_ekg/pages/bth_scan.dart';
import 'package:aplikasi_ekg/pages/home_page.dart';
import 'package:aplikasi_ekg/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class bth_before extends StatefulWidget {
  const bth_before({super.key});

  @override
  State<bth_before> createState() => _bth_beforeState();
}

class _bth_beforeState extends State<bth_before> {
  final myController = TextEditingController();
  soc_model _soc = soc_model();

  String receiveData = "";

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white_col,
      body: Center(
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
                  'Add New Device',
                  style: dark_blue_text_sty.copyWith(
                      fontSize: 30, fontWeight: medium),
                ),
                const Spacer(),
                Container(
                  width: 80,
                  height: 40,
                )
              ],
            ),
            const SizedBox(
              height: 59,
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  color: back_grey_col,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/bluetooth_pic.png'),
                      scale: 2.5)),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 350,
              height: 50,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: light_blue_col,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '1. Turn on Bluetooth on this device',
                textAlign: TextAlign.center,
                style:
                    white_text_sty.copyWith(fontSize: 20, fontWeight: regular),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 350,
              height: 50,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: light_blue_col,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '2. Turn on the ECG',
                textAlign: TextAlign.center,
                style:
                    white_text_sty.copyWith(fontSize: 20, fontWeight: regular),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 250,
              height: 50,
              child: ListTile(
                title: ElevatedButton(
                    child: Text(
                      'Search for devices',
                      style: white_text_sty.copyWith(
                          fontSize: 25, fontWeight: regular),
                    ),
                    onPressed: () async {
                      final BluetoothDevice? selectedDevice =
                          await Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                        return bth_after();
                      })));
                      if (selectedDevice != null) {
                        print('hehehe');
                        BluetoothConnection.toAddress(selectedDevice.address)
                            .then((value) {
                          // print('value: $value');
                          // print('hihihi');
                          value.input!.listen(olahdata).onDone(() {});
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home_Page()));
                      } else {}
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ChatPage(server: server);
    }));
  }

  void olahdata(Uint8List data) {
    try {
      setState(() {
        // print('aku olah data');
        receiveData = String.fromCharCodes(data);
        double data_raw = double.parse(receiveData);
        double data_ekg = (data_raw * 1.5) / 1023;
        print('data ekg: $data_ekg');
        // print('receive data: $receiveData');
        // print('raw ekg: $raw_ekg');
        DateTime _dateTime = DateTime.now();
        String data_waktu =
            '${_dateTime.hour}:${_dateTime.minute}:${_dateTime.second}:${_dateTime.millisecond}';
        _soc.socket.emit(
            'save_data', {'data_ekg': data_ekg, 'data_waktu': data_waktu});
      });
    } catch (e) {
      print(e);
    }
  }
}
