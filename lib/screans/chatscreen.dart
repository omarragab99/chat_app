import 'package:chatme/screans/signin.dart';
import 'package:chatme/screans/welcomesccreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User signInUser;

class ChatScreen extends StatefulWidget {
  static const String screanroute = 'chat_screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagETextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? massagetext;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user =
          _auth.currentUser; // Access the current user from Firebase Auth
      if (user != null) {
        signInUser = user;
        print(signInUser.email); // Assign the user to `signInUser` if not null
      }
    } catch (e) {
      print('Error fetching current user: $e'); // Log the error for debugging
    }
  }

  /*void getMassages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }*/
  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) print(message.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset("images/logo.png", height: 40),
            SizedBox(
              width: 15,
            ),
            Text(
              'MassageMe',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, Welcomescreen.screanroute);
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Messagestreambuilder(),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messagETextController,
                    onChanged: (value) {
                      massagetext = value;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your massage here ...',
                        border: InputBorder.none),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      messagETextController.clear();
                      _firestore.collection('messages').add({
                        'text': massagetext,
                        'sender': signInUser.email,
                        'time': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}

class Messagestreambuilder extends StatelessWidget {
  const Messagestreambuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        // Display a loading indicator if there's no data yet
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Safe to access snapshot.data after checking hasData
        final messages = snapshot.data!.docs.reversed;

        // Create widgets for each message
        List<Messageline> messagesWidget = [];
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = signInUser.email;
          final messageWidget = Messageline(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messagesWidget.add(messageWidget);
        }

        return Expanded(
            child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: messagesWidget));
      },
    );
  }
}

class Messageline extends StatelessWidget {
  const Messageline(
      {required this.sender,
      required this.text,
      super.key,
      required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(
                color: isMe ? Colors.orange : Colors.blue, fontSize: 15),
          ),
          Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              elevation: 5,
              color: isMe ? Colors.blue[800] : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 15, color: isMe ? Colors.white : Colors.black),
                ),
              )),
        ],
      ),
    );
  }
}
