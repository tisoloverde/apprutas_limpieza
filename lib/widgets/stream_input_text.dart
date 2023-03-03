import 'package:flutter/material.dart';

import 'package:solo_verde/widgets/input_text.dart';

class StreamInputText extends StatefulWidget {
  final bool isInit;
  final Stream<dynamic> streamVal;
  final Function(dynamic) onChange;
  final Function(String)? onEnter;
  final Function() onInit;
  final Function() onClear;
  final FocusNode? focusNode;

  const StreamInputText({
    super.key,
    required this.isInit,
    required this.streamVal,
    required this.onChange,
    this.onEnter,
    required this.onInit,
    required this.onClear,
    this.focusNode,
  });

  @override
  StreamInputTextState createState() => StreamInputTextState();
}

class StreamInputTextState extends State<StreamInputText> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

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
        if (widget.isInit) {
          _controller.text = snapshot.data;
          widget.onInit();
        }
        return InputText(
          focusNode: widget.focusNode,
          controller: _controller,
          // initialValue: snapshot.data,
          onChange: (String? val) => widget.onChange(val ?? ''),
          onEnter: widget.onEnter,
          onClear: () {
            _controller.text = '';
            widget.onClear();
          },
        );
      },
    );
  }
}
