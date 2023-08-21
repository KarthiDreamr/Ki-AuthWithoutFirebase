import 'package:auth/admin_page.dart';
import 'package:auth/dayscholar.dart';
import 'package:auth/error_page.dart';
import 'package:auth/mentor_page.dart';
import 'package:auth/student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final storage = const FlutterSecureStorage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void storeState(String userType) async {
    await widget.storage.write(key: "userType", value: userType);
  }

  void pageSwitch(String userType, bool write) {
    if (write) {
      storeState(userType);
    }

    if (userType == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiAdminPage()),
      );
    } else if (userType == "Hostel student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiStudentPage()),
      );
    } else if (userType == "Hostel Mentor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiMentorPage()),
      );
    } else if (userType == "Dayscholar student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiDayScholar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KiErrorPage()),
      );
    }
  }

  Future singInFun() async {
    var gresponse = await GoogleSignIn().signIn();
    print(gresponse);

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://dev-checkin.kct.ac.in/api/login/'));

    request.fields.addAll({'email': 'test_dayscholar@gmail.com'});

    /*
    testhostelstudent@gmail.com
    test_mentor@gmail.com
    test_hostel_admin@gmail.com
    test_dayscholar@gmail.com
    */

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      print("Response from Endpoint $responseString");
      var responseJson = json.decode(responseString);
      var userType = responseJson["authenticated successfully"];
      print("User Type is $userType");

      pageSwitch(userType, true);
    } else {
      print("Custom Error Response: ${response.reasonPhrase} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Auth"),
      ),
      body: Column(
        children: [
          const MyRadioMenu(),
          ElevatedButton.icon(
            onPressed: singInFun,
            icon: const Icon(Icons.abc),
            label: const Text("Google Auth"),
          ),
        ],
      ),
    );
  }
}

// Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         MenuAnchor(
//           childFocusNode: _buttonFocusNode,
//           menuChildren: <Widget>[
//             RadioMenuButton<Color>(
//               value: Colors.red,
//               shortcut: _redShortcut,
//               groupValue: _backgroundColor,
//               onChanged: _setBackgroundColor,
//               child: const Text('Red Background'),
//             ),
//             RadioMenuButton<Color>(
//               value: Colors.green,
//               shortcut: _greenShortcut,
//               groupValue: _backgroundColor,
//               onChanged: _setBackgroundColor,
//               child: const Text('Green Background'),
//             ),
//             RadioMenuButton<Color>(
//               value: Colors.blue,
//               shortcut: _blueShortcut,
//               groupValue: _backgroundColor,
//               onChanged: _setBackgroundColor,
//               child: const Text('Blue Background'),
//             ),
//           ],
//           builder:
//               (BuildContext context, MenuController controller, Widget? child) {
//             return TextButton(
//               focusNode: _buttonFocusNode,
//               onPressed: () {
//                 if (controller.isOpen) {
//                   controller.close();
//                 } else {
//                   controller.open();
//                 }
//               },
//               child: const Text('OPEN MENU'),
//             );
//           },
//         ),
//         Expanded(
//           child: Container(
//             color: _backgroundColor,
//           ),
//         ),
//       ],
//     );



/// Flutter code sample for [RadioMenuButton].

void main() => runApp(const MenuApp());

class MyRadioMenu extends StatefulWidget {
  const MyRadioMenu({super.key});

  @override
  State<MyRadioMenu> createState() => _MyRadioMenuState();
}

class _MyRadioMenuState extends State<MyRadioMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  Color _backgroundColor = Colors.red;
  late ShortcutRegistryEntry _entry;

  static const SingleActivator _redShortcut =
      SingleActivator(LogicalKeyboardKey.keyR, control: true);
  static const SingleActivator _greenShortcut =
      SingleActivator(LogicalKeyboardKey.keyG, control: true);
  static const SingleActivator _blueShortcut =
      SingleActivator(LogicalKeyboardKey.keyB, control: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _entry = ShortcutRegistry.of(context)
        .addAll(<ShortcutActivator, VoidCallbackIntent>{
      _redShortcut: VoidCallbackIntent(() => _setBackgroundColor(Colors.red)),
      _greenShortcut:
          VoidCallbackIntent(() => _setBackgroundColor(Colors.green)),
      _blueShortcut: VoidCallbackIntent(() => _setBackgroundColor(Colors.blue)),
    });
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    _entry.dispose();
    super.dispose();
  }

  void _setBackgroundColor(Color? color) {
    setState(() {
      _backgroundColor = color!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MenuAnchor(
          childFocusNode: _buttonFocusNode,
          menuChildren: <Widget>[
            RadioMenuButton<Color>(
              value: Colors.red,
              shortcut: _redShortcut,
              groupValue: _backgroundColor,
              onChanged: _setBackgroundColor,
              child: const Text('Red Background'),
            ),
            RadioMenuButton<Color>(
              value: Colors.green,
              shortcut: _greenShortcut,
              groupValue: _backgroundColor,
              onChanged: _setBackgroundColor,
              child: const Text('Green Background'),
            ),
            RadioMenuButton<Color>(
              value: Colors.blue,
              shortcut: _blueShortcut,
              groupValue: _backgroundColor,
              onChanged: _setBackgroundColor,
              child: const Text('Blue Background'),
            ),
          ],
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
            return TextButton(
              focusNode: _buttonFocusNode,
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: const Text('OPEN MENU'),
            );
          },
        ),
      ],
    );
  }
}

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: MyRadioMenu()),
    );
  }
}
