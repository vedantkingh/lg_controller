import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lg_controller/src/gdrive/FileRequests.dart';
import 'package:lg_controller/src/models/KMLData.dart';
import 'package:lg_controller/src/models/OverlayData.dart';
import 'package:lg_controller/src/resources/SQLDatabase.dart';
import 'package:lg_controller/src/ui/QRSenderDialog.dart';
import 'package:lg_controller/src/ui/QRReceiverDialog.dart';
import 'package:lg_controller/src/menu/POINavBarMenu.dart';
import 'package:lg_controller/src/utils/Images.dart';
import 'package:lg_controller/src/utils/SizeScaling.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

/// Content of profile page.
class ProfileContent extends StatefulWidget {
  ProfileContent();

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool loading;
  bool listLoading = false;
  bool admin = false;
  List<KMLData> data;

  @override
  void initState() {
    loading = true;
    data = List();
    getData();
    getPrivateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        8 + (8 * 0.7 * SizeScaling.getWidthScaling() - 1),
      ),
      child: (loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
              Stack(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          maxRadius: 32 * SizeScaling.getWidthScaling(),
                          backgroundColor: Colors.transparent,
                          backgroundImage: Images.PROFILE,
                        ),
                        (admin)
                            ? Text('Admin',
                                style: Theme.of(context).textTheme.titleMedium)
                            : Text('User',
                                style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (admin)
                            ? IconButton(
                                icon: Icon(
                                  IconData(59513, fontFamily: 'MaterialIcons'),
                                  color: Colors.black87,
                                ),
                                onPressed: () => setAdmin(false))
                            : TextButton(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AdminAccessDialog(
                                          () => setAdmin(true));
                                    },
                                  );
                                },
                                child: Text('Login',
                                    style: Theme.of(context).textTheme.titleMedium),
                              ),
                      ]),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 32,
                      child: IconButton(
                        color: Colors.black87,
                        icon:
                            Icon(IconData(58052, fontFamily: 'MaterialIcons')),
                        onPressed: () => receiveModule(),
                      ),
                    ),
                  ]),
              (listLoading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : PrivateData(this.data, admin),
            ]),
    );
  }

  /// Set admin state.
  setAdmin(bool admin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Admin', admin);
    setState(() {
      this.admin = admin;
    });
  }

  /// Get admin state.
  getData() async {
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    admin = prefs.getBool('Admin');
    if (admin == null) {
      admin = false;
      await prefs.setBool('Admin', admin);
    }
    setState(() {
      loading = false;
    });
  }

  /// Get private data of the user/admin.
  getPrivateData() async {
    data = await SQLDatabase().getPrivate();
    setState(() {
      listLoading = false;
    });
  }

  /// Show receiver dialog.
  receiveModule() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRReceiverDialog(onReceived);
      },
    );
  }

  /// Process the received module data.
  onReceived(String json) {
    try {
      OverlayData data = OverlayData.fromJson(jsonDecode(json));
      List<OverlayData> list = List();
      list.add(data);
      SQLDatabase().insertInTable(POINavBarMenu.PRIVATE_1.title, list);
      Toast.show(
        'KML successfully saved in your private directory.',
        textStyle: context,
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );
    } catch (e) {
      Toast.show(
        'Error occured in sharing module. Please retry.',
        textStyle: context,
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );
    }
    Navigator.of(context).pop();
  }
}

/// Private data list widget.
class PrivateData extends StatelessWidget {
  final List<KMLData> data;
  final bool admin;
  final FileRequests fileRequests;

  PrivateData(this.data, this.admin) : fileRequests = FileRequests();

  Widget build(BuildContext context) {
    return Container(
      height: 112,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        physics: BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(data[index].title),
              subtitle: Text(data[index].desc),
              trailing: (!admin)
                  ? IconButton(
                      icon: Icon(IconData(59405, fontFamily: 'MaterialIcons')),
                      onPressed: () => shareModule(context, data[index]))
                  : Container(
                      width: 96,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                  IconData(59405, fontFamily: 'MaterialIcons')),
                              onPressed: () =>
                                  shareModule(context, data[index])),
                          IconButton(
                              icon: Icon(
                                  IconData(58054, fontFamily: 'MaterialIcons')),
                              onPressed: () =>
                                  uploadFile(context, data[index])),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  /// Show send dialog.
  shareModule(context, KMLData data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRSenderDialog(jsonEncode(data));
      },
    );
  }

  /// Upload private data module as .kml file in Google drive.
  uploadFile(context, KMLData data) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Center(
            child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
    bool status = await fileRequests.uploadFile(data);
    if (status)
      Toast.show(
        'Successfully uploaded.',
        textStyle: context,
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
    else
      Toast.show(
        'Some error occured. Please try again.',
        textStyle: context,
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
    Navigator.of(context).pop();
  }
}

/// Dialog to enter passkey for admin access.
class AdminAccessDialog extends StatefulWidget {
  final Function onComplete;

  AdminAccessDialog(this.onComplete);

  @override
  _AdminAccessDialogState createState() => _AdminAccessDialogState();
}

class _AdminAccessDialogState extends State<AdminAccessDialog> {
  TextEditingController passkey_controller;
  final pass_key = GlobalKey<FormFieldState>();

  @override
  void initState() {
    passkey_controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Please enter admin passkey.',
          style: Theme.of(context).textTheme.titleMedium),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: Theme.of(context).textTheme.titleMedium),
        ),
        TextButton(
          onPressed: () {
            if (verifyPassCode(passkey_controller.text))
              widget.onComplete();
            else
              Toast.show(
                'Invalid pass code.',
                textStyle: context,
                duration: Toast.lengthShort,
                gravity: Toast.bottom,
              );
            Navigator.of(context).pop();
          },
          child: Text('Save', style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
      content: SingleChildScrollView(
        child: Container(
          width: 200 + 200 * 0.8 * (SizeScaling.getWidthScaling() - 1),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.always, key: pass_key,
            controller: passkey_controller,
            validator: (value) {
              if (value.length == 0) return 'Enter a valid value.';
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            decoration: new InputDecoration(
              labelText: "Passcode",
            ),
            maxLines: 1,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  /// Verify passcode.
  bool verifyPassCode(String val) {
    return val.compareTo('99879') == 0;
  }
}
