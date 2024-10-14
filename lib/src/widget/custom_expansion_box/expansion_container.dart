import 'package:flutter/material.dart';
import 'package:skeleton_kosmos/src/widget/custom_card/theme.dart';
import 'package:skeleton_kosmos/src/widget/custom_expansion_box/custom_expansion_box.dart';
import 'package:skeleton_kosmos/src/widget/custom_expansion_box/theme.dart';

class OpenableContainer extends StatefulWidget {
  final bool isDefaultOpened;
  final Widget header;
  final Widget? haedarCollapsed;
  final Widget body;
  final Function(bool)? collapsedCallback;

  final CustomExpansionPanelListThemeData? theme;
  final CustomCardThemeData? cardTheme;
  final String? themeName;

  const OpenableContainer({
    Key? key,
    this.isDefaultOpened = false,
    required this.header,
    required this.body,
    this.haedarCollapsed,
    this.collapsedCallback,
    this.cardTheme,
    this.theme,
    this.themeName,
  }) : super(key: key);

  @override
  State<OpenableContainer> createState() => _OpenableContainerState();
}

class _OpenableContainerState extends State<OpenableContainer> {
  bool isOpened = false;

  @override
  void initState() {
    isOpened = widget.isDefaultOpened;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionPanelList(
      theme: widget.theme,
      themeName: widget.themeName,
      cardTheme: widget.cardTheme,
      expansionCallback: (int index, bool isExpanded) {
        if (widget.collapsedCallback != null) {
          widget.collapsedCallback!(isExpanded);
        }
        setState(() {
          isOpened = !isOpened;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: isOpened,
          canTapOnHeader: true,
          headerBuilder: (_, isOpened) {
            return isOpened ? widget.header : widget.haedarCollapsed ?? widget.header;
          },
          body: widget.body,
        ),
      ],
    );
  }
}
