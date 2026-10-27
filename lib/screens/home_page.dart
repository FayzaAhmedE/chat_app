import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    'messages',
  );
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController =
      ScrollController(); // to scroll chat to the last message auto

  String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '1';

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    messages.add({
      'message': controller.text,
      'createdAt': DateTime.now(), // to arrange messages
      'id': currentUserEmail,
    });

    controller.clear();

    if (scrollController.hasClients) {
      scrollController.animateTo(
        0, //the start of the listView
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages
          .orderBy('createdAt', descending: true)
          .snapshots(), // to get messages and updata it auto
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        List<MessageModel> messagesList = [];
        for (var doc in snapshot.data!.docs) {
          messagesList.add(
            MessageModel.fromJson(doc.data() as Map<String, dynamic>),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.kprimaryColor,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/scholar.png', width: 50),
                const Text(
                  ' Chat',
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true, // to start list from the bottom to the top
                  controller: scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    if (messagesList[index].id == currentUserEmail) {
                      return ChatBubble(
                        isMe: true,
                        bgColor: AppColors.kprimaryColor,
                        message: messagesList[index].message,
                      );
                    } else {
                      return ChatBubble(
                        isMe: false,
                        bgColor: AppColors.kprimaryColor,
                        message: messagesList[index].message,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    sendMessage();
                  },
                  decoration: InputDecoration(
                    hintText: 'Send a message',
                    suffixIcon: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(Icons.send, color: AppColors.kprimaryColor),
                    ),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.kprimaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
