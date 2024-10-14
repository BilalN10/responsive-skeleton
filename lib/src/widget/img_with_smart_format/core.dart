import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeleton_kosmos/src/widget/img_with_smart_format/enum.dart';
import 'package:ui_kosmos_v4/micro_element/micro_element.dart';

/// Créer automatiquement une image avec le type demandé. Si l'image est un url internet, ajout automatique du cache.
///
/// {@category Widget}
class ImageWithSmartFormat extends StatelessWidget {
  final String path;

  final SmartImageType type;

  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final Color? color;

  const ImageWithSmartFormat({
    Key? key,
    required this.path,
    required this.type,
    this.boxFit,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SmartImageType.assetImage:
        return Image.asset(path, fit: boxFit ?? BoxFit.cover, width: width, height: height);
      case SmartImageType.networkImage:
        return CachedNetworkImage(
          imageUrl: path,
          fit: boxFit ?? BoxFit.cover,
          width: width,
          height: height,
          progressIndicatorBuilder: (_, __, ___) {
            return const LoaderClassique();
          },
          errorWidget: (_, __, ___) {
            return const Center(child: Icon(Icons.error_outline_rounded, color: Colors.red));
          },
        );
      case SmartImageType.svg:
        return SvgPicture.asset(path, width: width, color: color, height: height, fit: boxFit ?? BoxFit.cover);
    }
  }
}
