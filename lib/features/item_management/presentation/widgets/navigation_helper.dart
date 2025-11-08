import 'package:flutter/material.dart';
import '../pages/add_edit_item_page.dart';
import '../../domain/entities/item.dart';

/// Navigation helper for page transitions
class NavigationHelper {
  /// Navigate to add/edit item page with slide transition
  static void navigateToAddEditPage(BuildContext context, {Item? item}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddEditItemPage(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

