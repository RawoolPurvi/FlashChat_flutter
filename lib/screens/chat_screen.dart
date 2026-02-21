import 'package:flutter/material.dart';
import 'package:flash_card/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextControlling = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
 
  String messageText = "";

  void initState() {
    super.initState();
    getCurrentUser();
  }

  // to get the current user and store it in loggedInUser variable
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async{
  //   final messages = await _firestore.collection('messages').get();
  //   for(var message in messages.docs){
  //     print(message.data());
  //   }
  // }

  void messageStream() async {
    // snapshot : when there is a new message added to the collection, it will automatically update the stream and I will be notified about any new messages added to the collection
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              //Implement logout functionality
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot
                      .data!
                      .docs
                      .reversed; //to show the latest message at the bottom
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final currentUser = loggedInUser!.email;
                    if(currentUser == messageSender){
                      // message from the loggedin user
                    }
                    final messageWidget =  MessageBubble(messageText: messageText, messageSender: messageSender, isMe: currentUser == messageSender);
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true, //user does not need to scroll down to display recent messages.
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 20.0,
                      ),
                      children: messageWidgets,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextControlling,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextControlling.clear(); //To clear the message on the txt field on "send" click
                      //Implement send functionality.
                      // messageText + loggedInUser.email
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser!.email,
                      });
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.messageText, required this.messageSender, required this.isMe});
  final String messageText;
  final String messageSender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$messageSender', style: TextStyle(fontSize: 12.0, color: Colors.black54),),
          Material(
            color:isMe ? Colors.lightBlueAccent : Colors.lightGreenAccent,
            borderRadius:isMe ? BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0),topLeft: Radius.circular(30.0)) : BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0),topRight: Radius.circular(30.0)),
            elevation: 5.0,
            child: Padding(          
              padding: const EdgeInsets.all(10.0),
              child: Text('$messageText',
              style: TextStyle(
                fontSize: 20.0,
              ),
              ),
            ),
            ),
        ],
      ),
    );
  }
}
