import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_kosmos/src/widget/custom_card/theme.dart';
import 'package:skeleton_kosmos/src/widget/custom_expansion_box/theme.dart';

/// Widget de liste déroulante
///
/// {@category Widget}
class CustomExpansionPanelList extends StatelessWidget {
  final List<ExpansionPanel> children;
  final ExpansionPanelCallback? expansionCallback;
  final Duration animationDuration;

  final double? borderRadius;
  final Color? color;
  final Duration? duration;
  final List<BoxShadow>? shadow;
  final EdgeInsets? padding;
  final double? collapsedHeight;

  final CustomExpansionPanelListThemeData? theme;
  final CustomCardThemeData? cardTheme;

  final String? themeName;
  final Widget? expansionButton;
  final bool enableRotationOnExpand;

  const CustomExpansionPanelList({
    Key? key,
    this.children = const <ExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,

    /// Theme
    this.borderRadius,
    this.color,
    this.duration,
    this.shadow,
    this.padding,
    this.collapsedHeight,
    this.theme,
    this.cardTheme,
    this.themeName,
    this.expansionButton,
    this.enableRotationOnExpand = true,
  }) : super(key: key);

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    final themeData = loadThemeData(cardTheme, "custom_card", () => const CustomCardThemeData())!;
    final expansionTheme = loadThemeData(theme, "expansion_panel", () => const CustomExpansionPanelListThemeData())!;

    for (int index = 0; index < children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1)) {
        items.add(Divider(
          key: _SaltedKey<BuildContext, int>(context, index * 2 - 1),
          height: 15.0,
          color: Colors.transparent,
        ));
      }

      final Widget header = InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
        highlightColor: Colors.transparent,
        onTap: () {
          if (expansionCallback != null) expansionCallback!(index, !children[index].isExpanded);
        },
        child: SizedBox(
          height: collapsedHeight ?? expansionTheme.collapsedHeight,
          child: Padding(
            padding: padding ?? expansionTheme.headerPadding ?? EdgeInsets.symmetric(vertical: formatHeight(15), horizontal: formatWidth(20)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.fastOutSlowIn,
                    child: children[index].headerBuilder(
                      context,
                      children[index].isExpanded,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (expansionCallback != null) expansionCallback!(index, !children[index].isExpanded);
                  },
                  child: AnimatedRotation(
                    turns: enableRotationOnExpand
                        ? _isChildExpanded(index)
                            ? .5
                            : 0
                        : 0,
                    duration: animationDuration,
                    child: expansionButton ?? expansionTheme.expansionButton ?? const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      items.add(
        Container(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          child: Material(
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? themeData.radius ?? 11)),
                color: color ?? themeData.backgroundColor ?? Colors.white,
                boxShadow: shadow ??
                    expansionTheme.shadow ??
                    [
                      BoxShadow(
                        color: themeData.shadowColor ?? const Color(0xFF021C36).withOpacity(.02),
                        blurRadius: themeData.blurRadius ?? 5,
                        spreadRadius: themeData.spreadRadius ?? 3,
                      ),
                    ],
              ),
              child: Column(
                children: <Widget>[
                  header,
                  AnimatedCrossFade(
                    firstChild: Container(height: 0.0),
                    secondChild: Padding(
                      padding: padding ?? expansionTheme.contentPadding ?? EdgeInsets.symmetric(vertical: formatHeight(15), horizontal: formatWidth(20)),
                      child: children[index].body,
                    ),
                    firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                    secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                    sizeCurve: Curves.fastOutSlowIn,
                    crossFadeState: _isChildExpanded(index) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: animationDuration,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (_isChildExpanded(index) && index != children.length - 1) {
        items.add(Divider(
          key: _SaltedKey<BuildContext, int>(context, index * 2 + 1),
          height: 15.0,
        ));
      }
    }

    return Column(
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}
