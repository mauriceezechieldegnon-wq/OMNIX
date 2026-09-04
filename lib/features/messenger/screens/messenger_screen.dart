import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnix/core/constants/app_colors.dart';
import 'package:omnix/core/models/user_model.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final currentUserId = _auth.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("OMNIX MESSENGER 💬", style: TextStyle(color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.darkCard,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              style: const TextStyle(color: AppColors.textLight),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase().trim()),
              decoration: InputDecoration(
                hintText: "Rechercher un abonné par pseudo...",
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.neonYellow),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.electricPurple),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.neonYellow));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Aucun abonné trouvé.", style: TextStyle(color: AppColors.textMuted)),
                  );
                }

                final users = snapshot.data!.docs
                    .map((doc) => UserModel.fromFirestore(doc))
                    .where((u) => u.uid != currentUserId)
                    .where((u) => u.pseudo.toLowerCase().contains(_searchQuery))
                    .toList();

                if (users.isEmpty) {
                  return const Center(
                    child: Text("Aucun joueur ne correspond à la recherche.", style: TextStyle(color: AppColors.textMuted)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final targetUser = users[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.electricPurple.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(targetUser.avatarUrl),
                          backgroundColor: AppColors.background,
                        ),
                        title: Text(
                          targetUser.pseudo,
                          style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          targetUser.isVIP ? "Gold Elite VIP" : "Joueur PRO • ${targetUser.points} PTS",
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        trailing: const Icon(Icons.chat_bubble_outline, color: AppColors.neonYellow),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(targetUser: targetUser),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final UserModel targetUser;
  const ChatDetailScreen({super.key, required this.targetUser});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() async {
    final text = _msgController.text.trim();
    final currentUserId = _auth.currentUser?.uid;
    if (text.isEmpty || currentUserId == null) return;

    _msgController.clear();

    await _db.collection('chats').add({
      'senderId': currentUserId,
      'receiverId': widget.targetUser.uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'read',
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _auth.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.targetUser.avatarUrl),
            ),
            const SizedBox(width: 10),
            Text(widget.targetUser.pseudo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppColors.darkCard,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.neonYellow));
                }

                final messages = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final s = data['senderId'];
                  final r = data['receiverId'];
                  return (s == currentUserId && r == widget.targetUser.uid) ||
                      (s == widget.targetUser.uid && r == currentUserId);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUserId;
                    final text = data['text'] ?? '';

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.electricPurple : AppColors.darkCard,
                          borderRadius: BorderRadius.circular(14),
                          border: isMe ? null : Border.all(color: AppColors.metallicBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(text, style: const TextStyle(color: AppColors.textLight)),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.done_all, size: 14, color: Colors.blueLight),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.darkCard,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: AppColors.textLight),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: "...",
                      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.neonYellow),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
