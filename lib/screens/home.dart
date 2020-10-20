import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';
import 'package:flutter_instant_messenger/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instant_messenger/widgets/topbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Conversation> _convHistory;

  void _signOut() {
    Provider.of<UserState>(context, listen: false).signOut(context);
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      appBar: TopBar(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.all(10),
            child: Card(
              color: Color(0xFF393E46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: InkWell(
                onTap: null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "UserName",
                                      style: TextStyle(
                                        fontFamily: "SourceSansPro",
                                        fontSize: 24,
                                        color: Color(0xFFEFF6EE),
                                      ),
                                    ),
                                    Text(
                                      "18/10/2020",
                                      style: TextStyle(
                                        fontFamily: "SourceSansPro",
                                        fontSize: 16,
                                        color: Color(0xFFEFF6EE),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
