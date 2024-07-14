import 'package:flutter/material.dart';
import 'package:web_client/domain/todo_model.dart';

typedef CheckBoxTapCallback = void Function(TodoModel);

class TodoItemWidget extends StatelessWidget {
  final TodoModel item;
  final CheckBoxTapCallback onCheckBoxTap;

  const TodoItemWidget({
    required this.item,
    required this.onCheckBoxTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.title,
            style: item.isCompleted
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
        ),
        GestureDetector(
          onTap: () => onCheckBoxTap(item),
          child: Icon(
            item.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            key: ValueKey('item_icon_${item.id}'),
          ),
        )
      ],
    );
  }
}
