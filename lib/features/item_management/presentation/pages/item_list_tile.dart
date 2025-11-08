import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/entities/item.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Item list tile widget with swipe to delete
class ItemListTile extends StatefulWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ItemListTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<ItemListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onDelete(),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            icon: Icons.delete,
            label: AppStrings.delete,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ],
      ),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ListTile(
            title: Text(
              widget.item.title,
            ),
            subtitle: widget.item.description != null &&
                    widget.item.description!.isNotEmpty
                ? Text(
                    widget.item.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  )
                : null,
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}

