import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class ListItemSheet extends StatefulWidget {
  const ListItemSheet({super.key});

  @override
  State<ListItemSheet> createState() => _ListItemSheetState();
}

class _ListItemSheetState extends State<ListItemSheet> {
  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  ItemCondition _cond = ItemCondition.likeNew;
  bool _swapOnly = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.add_photo_alternate_outlined,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('List a New Item', style: AppTheme.displaySm.copyWith(fontSize: 20)),
                        const SizedBox(height: 2),
                        Text('Quick post · be honest about condition',
                            style: AppTheme.bodySm),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title field
              TextField(
                controller: _titleCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'What are you selling?',
                  hintText: 'e.g. Calculus Textbook (Stewart 8th Ed)',
                  prefixIcon: Icon(Icons.sell_outlined),
                ),
              ),
              const SizedBox(height: 14),

              // Price
              TextField(
                controller: _priceCtrl,
                enabled: !_swapOnly,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _swapOnly ? 'Swap only — no price needed' : 'Price (RM)',
                  hintText: _swapOnly ? '—' : 'e.g. 25',
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
              ),
              const SizedBox(height: 20),

              // Condition selector
              Text('Condition', style: AppTheme.labelLg),
              const SizedBox(height: 10),
              Row(
                children: ItemCondition.values.map((c) {
                  final sel = _cond == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _cond = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? c.color : c.bgColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: sel ? c.color : c.color.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          c.label,
                          style: TextStyle(
                            color: sel ? Colors.white : c.color,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Swap toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppTheme.bgLight,
                  borderRadius: BorderRadius.circular(AppTheme.r16),
                ),
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  thumbColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected)
                        ? AppTheme.primary
                        : AppTheme.textHint,
                  ),
                  trackColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected)
                        ? AppTheme.primary.withValues(alpha: 0.2)
                        : AppTheme.border,
                  ),
                  title: Text('Swap Only', style: AppTheme.headingSm),
                  subtitle:
                      Text('Exchange for another item', style: AppTheme.bodySm),
                  value: _swapOnly,
                  onChanged: (v) => setState(() => _swapOnly = v),
                ),
              ),
              const SizedBox(height: 24),

              // Publish
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.r16)),
                  ),
                  onPressed: _publish,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rocket_launch_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Publish Listing',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _publish() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Give your item a title first.')),
      );
      return;
    }
    final price = _swapOnly ? 0.0 : (double.tryParse(_priceCtrl.text.trim()) ?? 0);
    final p = Product(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      priceRm: price,
      condition: _cond,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop',
      swapOnly: _swapOnly,
      category: 'New',
      listedAt: DateTime.now(),
    );
    context.read<AuthProvider>().addListing(p);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✓ Listed! Happy swapping.')),
    );
  }
}
