import 'package:cached_network_image/cached_network_image.dart';
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
    UserInfo userInfo = Provider.of<UserInfo>(context, listen: false);
    convState.userUid = userInfo.userUid = Provider.of<UserState>(context, listen: false).currentUser().uid;
    userInfo.trackCurrentUserInfo();
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
                    UserModel userData = snapshot.data as UserModel;
                    return SizedBox(
                      height: 108,
                      child: Card(
                        color: Color(0xFFA3F7BF),
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
                              'conversation': state.history.conversationList[index],
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
                                    userData.profileImageUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: userData.profileImageUrl,
                                            imageBuilder: (context, imageProvider) => Padding(
                                              padding: const EdgeInsets.only(left: 8, top: 5, right: 4),
                                              child: Container(
                                                width: 90.0,
                                                height: 90.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => Icon(
                                              Icons.account_circle_rounded,
                                              size: 100,
                                              color: Color(0xFF29A19C),
                                            ),
                                            errorWidget: (context, url, error) => Icon(
                                              Icons.account_circle_rounded,
                                              size: 100,
                                              color: Color(0xFF29A19C),
                                            ),
                                          )
                                        : Icon(
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
                                                userData.fullName,
                                                style: TextStyle(
                                                  fontFamily: "SourceSansPro",
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text(
                                                  DateFormat('d MMM - H:mm').format(state
                                                      .history.conversationList[index].messageList.first.datetime
                                                      .toLocal()),
                                                  style: TextStyle(
                                                    fontFamily: "SourceSansPro",
                                                    fontSize: 16,
                                                    color: Colors.black,
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
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/contacts'),
        child: Icon(Icons.message, color: Colors.white),
        backgroundColor: Color(0xFFA3F7BF),
      ),
    );
  }
}
