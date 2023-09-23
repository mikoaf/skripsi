import 'dart:async';
// import 'dart:ffi';
import 'dart:typed_data';

import 'package:aplikasi_ekg/model.dart';
import 'package:aplikasi_ekg/pages/bth_after.dart';
import 'package:aplikasi_ekg/pages/bth_before.dart';
import 'package:aplikasi_ekg/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  soc_model _soc = soc_model();
  late List<LiveData> chartData;
  ChartSeriesController? _chartSeriesController;

  @override
  void initState() {
    super.initState();
    _soc.hehe();
    _soc.kirimData(1, 2);
    print('hehe');
    _soc.start();
    chartData = getChartData();
    _soc.socket.on('resp_ekg_graph', (data) {
      setState(() {
        DateTime time = DateTime.now();
        chartData.add(LiveData(time, data['value']));
        chartData.removeAt(0);
        _chartSeriesController?.updateDataSource(
            addedDataIndex: chartData.length - 1, removedDataIndex: 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back_grey_col,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/img_background.png'),
              alignment: const Alignment(0.0, -1.0),
            )),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Logo_EKG.png'))),
                ),
                Text(
                  'ECG Portable',
                  style: white_text_sty.copyWith(
                      fontSize: 40, fontWeight: regular),
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  width: 350,
                  height: 350,
                  child: SfCartesianChart(
                    series: <LineSeries<LiveData, DateTime>>[
                      LineSeries<LiveData, DateTime>(
                        onRendererCreated: (ChartSeriesController controller) {
                          _chartSeriesController = controller;
                        },
                        dataSource: chartData,
                        color: Color.fromARGB(255, 74, 46, 255),
                        xValueMapper: (LiveData sales, _) => sales.time,
                        yValueMapper: (LiveData sales, _) => sales.speed,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        markerSettings: MarkerSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                    primaryXAxis: DateTimeAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        dateFormat: DateFormat.Hms(),
                        title: AxisTitle(text: 'Time (s)')),
                    primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(size: 0),
                        title: AxisTitle(text: 'Voltage (V)')),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 50,
                        child: ListTile(
                          title: ElevatedButton(
                            child: Text(
                              'Connect',
                              style: white_text_sty.copyWith(
                                  fontSize: 30, fontWeight: regular),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const bth_before()));
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: dark_blue_col,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(DateTime.now(), 0),
      LiveData(DateTime.now(), 0),
      LiveData(DateTime.now(), 0),
      LiveData(DateTime.now(), 0),
      LiveData(DateTime.now(), 0),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final DateTime time;
  final num speed;
}
