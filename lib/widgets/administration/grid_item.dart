import 'package:fc_ui/models/settings_category.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
  });

  final SettingsCategory category;
  final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/images/background.png'),
          //   fit: BoxFit.cover,
          // ),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.3),
              category.color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          textAlign: TextAlign.center,
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
