import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../util/constants.dart';
import '../model/message.dart';
import 'instant_messaging_bloc.dart';
import 'instant_messaging_state.dart';

class InstantMessagingScreen extends StatefulWidget {
  InstantMessagingScreen({Key key, @required this.displayName, @required this.chatroomId})
      : super(key: key);

  final String displayName;
  final String chatroomId;
  final TextEditingController _textEditingController = IMTextEditingController();

  @override
  State<StatefulWidget> createState() => _InstantMessagingState(chatroomId);
}

class _InstantMessagingState extends State<InstantMessagingScreen> {
  _InstantMessagingState._(this._bloc);

  _InstantMessagingState(String chatroomId) : this._(InstantMessagingBloc(chatroomId));

  final InstantMessagingBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstantMessagingBloc>(
      bloc: _bloc,
      child: InstantMessagingWidget(widget: widget),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class InstantMessagingWidget extends StatelessWidget {
  const InstantMessagingWidget({Key key, @required this.widget}) : super(key: key);

  final InstantMessagingScreen widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.displayName)),
      body: BlocBuilder(
        bloc: BlocProvider.of<InstantMessagingBloc>(context),
        builder: (context, InstantMessagingState state) {
          if (state.error) {
            return Center(
              child: Text("An error ocurred"),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: UIConstants.STANDARD_PADDING),
                        padding: EdgeInsets.symmetric(
                            vertical: UIConstants.SMALLER_PADDING,
                            horizontal: UIConstants.SMALLER_PADDING),
                        child: TextField(
                          controller: widget._textEditingController,
                          focusNode: FocusNode(),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.blueAccent,
                          decoration: InputDecoration(hintText: "Your message..."),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            _send(context, widget._textEditingController.text);
                          }),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: UIConstants.SMALLER_PADDING,
                        vertical: UIConstants.SMALLER_PADDING,
                      ),
                      itemBuilder: (context, index) =>
                          _buildMessageItem(state.messages[state.messages.length - 1 - index]),
                      itemCount: state.messages.length,
                      reverse: true,
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMessageItem(Message message) {
    if (message.outgoing) {
      return Container(
        child: Text(
          message.value,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.end,
        ),
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent, borderRadius: BorderRadius.all(Radius.circular(6.0))),
        padding: EdgeInsets.all(UIConstants.SMALLER_PADDING),
        margin: EdgeInsets.symmetric(
          vertical: UIConstants.SMALLER_PADDING / 2.0,
          horizontal: 0.0,
        ),
      );
    } else {
      return Container(
        child: Text(
          message.value,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.all(Radius.circular(6.0))),
        padding: EdgeInsets.all(UIConstants.SMALLER_PADDING),
        margin: EdgeInsets.symmetric(
          vertical: UIConstants.SMALLER_PADDING / 2.0,
          horizontal: 0.0,
        ),
      );
    }
  }

  void _send(BuildContext context, String text) {
    BlocProvider.of<InstantMessagingBloc>(context).send(text);
    widget._textEditingController.text = "";
  }
}

class IMTextEditingController extends TextEditingController {}
