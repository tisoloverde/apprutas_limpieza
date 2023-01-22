import 'package:flutter/material.dart';

import 'package:solo_verde/widgets/input_text.dart';

class StreamInputText extends StatefulWidget {
  final Stream<dynamic> streamVal;
  final Function(dynamic) onChange;
  final Function(String)? onEnter;

  const StreamInputText({
    super.key,
    required this.streamVal,
    required this.onChange,
    this.onEnter,
  });

  @override
  StreamInputTextState createState() => StreamInputTextState();
}

class StreamInputTextState extends State<StreamInputText> {
  // final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: widget.streamVal,
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        /*_controller.text = snapshot.data ?? '';
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );*/
        if (!snapshot.hasData) return const SizedBox();
        return InputText(
          // controller: _controller,
          initialValue: snapshot.data ?? '',
          onChange: (String? val) => widget.onChange(val ?? ''),
          onEnter: widget.onEnter,
        );
      },
    );
  }
}
