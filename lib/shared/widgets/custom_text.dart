part of './widgets.dart';

class CustomText extends StatefulWidget {
  final String text;
  final Color? color;
  final FontStyle? style;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String? family;

  const CustomText({
    required this.text,
    this.color,
    this.style,
    this.fontWeight,
    this.fontSize,
    this.family,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        // decoration: widget.underline
        //     ? TextDecoration.underline
        //     : (widget.strikeThrough ? TextDecoration.lineThrough : null),
        color: widget.color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        fontStyle: widget.style,
        fontFamily: widget.family,
      ),
    );
  }
}
