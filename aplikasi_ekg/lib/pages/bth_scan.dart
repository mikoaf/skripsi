import 'dart:async';

import 'package:aplikasi_ekg/pages/bth_after.dart';
import 'package:aplikasi_ekg/pages/bth_before.dart';
import 'package:aplikasi_ekg/pages/home_page.dart';
import 'package:aplikasi_ekg/theme.dart';
import 'package:flutter/material.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class bth_scan extends StatefulWidget {
  const bth_scan({super.key});

  @override
  State<bth_scan> createState() => _bth_scanState();
}

class _bth_scanState extends State<bth_scan> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 15), (() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => bth_after(),
        ),
      );
    }));
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
                        builder: (context) => const Home_Page(),
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/image/back_pic.png'))),
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
            SizedBox(
              height: 70,
            ),
            WidgetCircularAnimator(
              size: 350,
              innerIconsSize: 3,
              outerIconsSize: 3,
              innerAnimation: Curves.easeInOutBack,
              outerAnimation: Curves.easeInOutBack,
              innerColor: Colors.deepPurple,
              outerColor: Colors.orangeAccent,
              innerAnimationSeconds: 10,
              outerAnimationSeconds: 10,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200]),
                child: Image.asset('assets/images/bluetooth_pic.png'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Scanning...',
              style:
                  dark_blue_text_sty.copyWith(fontSize: 30, fontWeight: medium),
            ),
            SizedBox(
              height: 180,
            ),
            Container(
              width: 150,
              height: 50,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const bth_before(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    backgroundColor: dark_blue_col,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Text(
                  'Cancel',
                  style: white_text_sty.copyWith(
                      fontSize: 25, fontWeight: regular),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
