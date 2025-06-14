import 'dart:developer';

import 'package:dojah_kyc_sdk_flutter/dojah_extra_flutter_data.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dojah_kyc_sdk_flutter/dojah_kyc_sdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

const inputRadius = 10.0;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _widgetIdCtrl =
      TextEditingController(text: "67a31733f84e4cd6ffbcf06a");
  final TextEditingController _refIdCtrl = TextEditingController(text: null);
  final TextEditingController _emailCtrl = TextEditingController(text: null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
        constraints: const BoxConstraints(maxHeight: 43, minHeight: 38),
        contentPadding: EdgeInsets.symmetric(vertical: 4),
        hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(),
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 0.4),
            borderRadius: BorderRadius.circular(inputRadius)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.4),
            borderRadius: BorderRadius.circular(inputRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.4),
            borderRadius: BorderRadius.circular(inputRadius)),
        prefixIcon: const Icon(Icons.numbers));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dojah Flutter Sample'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: TextFormField(
                    controller: _widgetIdCtrl,
                    keyboardType: TextInputType.text,
                    decoration: inputDecoration.copyWith(
                        prefixIcon: const Icon(Icons.ac_unit_sharp),
                        hintText: "Enter Widget Id"),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _refIdCtrl,
                  decoration: inputDecoration.copyWith(
                      prefixIcon: const Icon(Icons.text_fields_rounded),
                      hintText: "Enter Reference Id"),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration.copyWith(
                      prefixIcon: const Icon(Icons.alternate_email),
                      hintText: "Enter Email"),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(inputRadius))),
                      onPressed: () async {
                        try {
                          log("start launching");
                          final result = await DojahKyc.launch(
                              _widgetIdCtrl.text,
                              referenceId: _refIdCtrl.text.isNotEmpty
                                  ? _refIdCtrl.text
                                  : null,
                              email: _emailCtrl.text.isNotEmpty
                                  ? _emailCtrl.text
                                  : null,
                              extraUserData: ExtraUserData(
                                // userData: UserData(firstName: "Ola",lastName: "Shittu",dob: "12-03-1995"),
                                govData: GovData(bvn: "12345678901"),
                                // govId: GovId(national: ""),
                                // location: Location(latitude: "32323"),
                                // businessData: BusinessData(cac: "1234567890"),
                                // address: "Isale Eko",
                                // metadata: {"key": "value"},
                              ));
                          log("result is $result");
                        } on PlatformException {
                          log("platform error");
                        }
                      },
                      child: const Text("Launch")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
