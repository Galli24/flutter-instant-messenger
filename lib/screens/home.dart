import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:flutter_instant_messenger/widgets/topbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConversationState convState;

  @override
  void initState() {
    convState = Provider.of<ConversationState>(context, listen: false);
    convState.userUid = Provider.of<UserState>(context, listen: false).currentUser().uid;
    convState.trackMessageHistory();
    super.initState();
  }

  @override
  void dispose() {
    convState.stopTrackingMessageHistory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      appBar: TopBar(context),
      body: SafeArea(
        child: Consumer<ConversationState>(
          builder: (context, state, child) {
            return ListView.builder(
              itemCount: state.history.conversationList.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: state.getParticipant(state.history.conversationList[index]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    return Card(
                      color: Color(0xFF393E46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/conversation',
                          arguments: {
                            'conversationUid': state.history.conversationList[index].id,
                            'userModel': snapshot.data as UserModel
                          },
                        ),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.account_circle_rounded,
                                    size: 100,
                                    color: Color(0xFF29A19C),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (snapshot.data as UserModel).fullName,
                                              style: TextStyle(
                                                fontFamily: "SourceSansPro",
                                                fontSize: 24,
                                                color: Color(0xFFEFF6EE),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Text(
                                                DateFormat('H:mm - d MMM').format(state
                                                    .history.conversationList[index].messageList.last.datetime
                                                    .toLocal()),
                                                style: TextStyle(
                                                  fontFamily: "SourceSansPro",
                                                  fontSize: 16,
                                                  color: Color(0xFFEFF6EE),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
