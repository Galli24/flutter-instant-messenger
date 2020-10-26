import 'package:flutter/material.dart';
import 'package:flutter_instant_messenger/models/conversation_models.dart';
import 'package:flutter_instant_messenger/models/user.dart';
import 'package:flutter_instant_messenger/services/conversation_service.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  ConversationState _convState;
  List<UserModel> _contacts = new List<UserModel>();
  List<UserModel> _filteredContacts = new List<UserModel>();

  Widget _currentAppBarTitle = new Text('Contacts', style: kBlackTextStyle);
  Icon _currentIcon = new Icon(Icons.search);

  @override
  void initState() {
    _convState = Provider.of<ConversationState>(context, listen: false);
    _getContacts();
    super.initState();
  }

  void _getContacts() async {
    List<UserModel> tempContacts = await _convState.getContacts();
    setState(() => _contacts = _filteredContacts = tempContacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6EE),
      appBar: AppBar(
        backgroundColor: Color(0xFFA3F7BF),
        iconTheme: IconThemeData(color: Colors.black),
        title: _currentAppBarTitle,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: _currentIcon,
            onPressed: () {
              setState(() {
                if (_currentIcon.icon == Icons.search) {
                  _currentIcon = new Icon(Icons.close);
                  _currentAppBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.black),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() => _filteredContacts = _contacts
                          .where((user) => user.fullName.toLowerCase().contains(value.toLowerCase()))
                          .toList());
                    },
                  );
                } else {
                  _currentIcon = new Icon(Icons.search);
                  _currentAppBarTitle = new Text('Contacts', style: kBlackTextStyle);
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _filteredContacts.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.all(10),
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
                onTap: () async {
                  Conversation convId = await _convState.getConversationWithUser(_filteredContacts[index].id);
                  Navigator.pushReplacementNamed(
                    context,
                    '/conversation',
                    arguments: {'conversation': convId, 'userModel': _filteredContacts[index]},
                  );
                },
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
                                      _filteredContacts[index].fullName,
                                      style: TextStyle(
                                        fontFamily: "SourceSansPro",
                                        fontSize: 24,
                                        color: Colors.black,
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
          ),
        ),
      ),
    );
  }
}
