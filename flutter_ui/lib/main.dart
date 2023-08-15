import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zego Video conference',
      home: HomePage(),
    );
  }
}

//Generate userId with 6 digit
//Generate conferenceId with 10 digit
final String userId = Random().nextInt(90000 + 100000).toString();
final String conferenceId =
    (Random().nextInt(10000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0');

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final conferenceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff034ada),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
            'https://www.codester.com/static/uploads/items/000/030/30002/preview/011.jpg',
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          Text("Your UserID : $userId"),
          const Text("PLease Test For two devices"),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            maxLength: 10,
            keyboardType: TextInputType.number,
            controller: conferenceIdController,
            decoration: const InputDecoration(
              labelText: 'Join a Meeting using Meeting Id',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => jumpToMeetingPage(context,
                conferenceId: conferenceIdController.text),
            child: Text('Join a Meeting'),
            style: buttonStyle,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () =>
                jumpToMeetingPage(context, conferenceId: conferenceId),
            child: Text('Start a New Meeting'),
            style: buttonStyle,
          ),
        ]),
      ),
    );
  }

  //Go TO Meeting Page
  jumpToMeetingPage(BuildContext context, {required String conferenceId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoConferencePage(
                  conferenceId: conferenceId,
                )));
  }
}

//VideoConference Page
class VideoConferencePage extends StatelessWidget {
  VideoConferencePage({super.key, required this.conferenceId});

  final String conferenceId;
  //Read AppId and sign
  final int appId = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID:
            appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: 'user_$userId',
        conferenceID: conferenceId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}
