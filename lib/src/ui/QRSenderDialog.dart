import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:lg_controller/src/osc/OSCActions.dart';
import 'package:toast/toast.dart';

/// Dialog to send module data.
class QRSenderDialog extends StatefulWidget {
  final String data;

  QRSenderDialog(this.data);

  @override
  _QRSenderDialogState createState() => _QRSenderDialogState();
}

class _QRSenderDialogState extends State<QRSenderDialog> {
  String data = "";

  @override
  void initState() {
    scan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sending..', style: Theme.of(context).textTheme.titleMedium),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Scan the barcode of receiver.
  Future scan() async {
    try {
      ScanResult datascan = await BarcodeScanner.scan();
      String data=datascan.rawContent;
      setState(() => this.data = data);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.data = "";
        });
      } else {
        setState(() => this.data = "");
      }
    } on FormatException {
      setState(() => this.data = "");
    } catch (e) {
      setState(() => this.data = "");
    }
    if (this.data.compareTo("") == 0)
      Navigator.of(context).pop();
    else
      sendModule();
  }

  /// Initiate sending of module.
  sendModule() async {
    data = data.split(',')[0];
    if (!validIP(data)) {
      Navigator.of(context).pop();
      Toast.show(
        'Invalid receiver.',
        textStyle: context,
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );
      return;
    }
    await OSCActions().shareModule(data, widget.data);
    Navigator.of(context).pop();
    Toast.show(
      'Module sent successfully.',
      textStyle: context,
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
    );
  }

  /// Check if receiver IP is valid.
  bool validIP(String data) {
    List<String> val = data.split('.');
    if (val.length != 4) return false;
    try {
      for (var i in val)
        if (int.parse(i) < 0 || int.parse(i) > 255) return false;
    } catch (e) {
      return false;
    }
    return true;
  }
}
