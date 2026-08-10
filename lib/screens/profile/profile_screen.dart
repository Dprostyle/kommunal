import 'package:flutter/cupertino.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/repositories/profile_repository.dart';
import '../../models/payment_card.dart';
import '../../models/utility_account.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_card.dart';
import '../../widgets/settings_row.dart';
import 'widgets/simple_info_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profileRepository,
  });

  final ProfileRepository profileRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PaymentCard? _card;
  List<UtilityAccount> _accounts = const [];
  String _language = 'Русский';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        widget.profileRepository.getCard(),
        widget.profileRepository.getAccounts(),
        widget.profileRepository.getLanguage(),
      ]);
      if (!mounted) return;
      setState(() {
        _card = results[0] as PaymentCard;
        _accounts = results[1] as List<UtilityAccount>;
        _language = results[2] as String;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text(
          'Вы уверены, что хотите выйти? Это демо-действие без реального выхода.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Вы вышли'),
          content: const Text(
            'В демо-режиме сессия не завершается. Подключите авторизацию позже.',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: _loading
            ? const EmptyState(kind: EmptyStateKind.loading)
            : CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(onRefresh: _load),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPaddingH,
                      AppDimensions.space16,
                      AppDimensions.screenPaddingH,
                      AppDimensions.space32,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const Text('Профиль', style: AppTextStyles.screenTitle),
                        const SizedBox(height: AppDimensions.space24),
                        SectionCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              SettingsRow(
                                title: 'Моя карта',
                                subtitle: _card?.maskedNumber ?? '—',
                                icon: CupertinoIcons.creditcard_fill,
                                iconBackground: AppColors.cardIconBg,
                                iconColor: AppColors.primary,
                                onTap: () => showSimpleInfoSheet(
                                  context,
                                  title: 'Моя карта',
                                  message: _card == null
                                      ? 'Карта не добавлена.'
                                      : '${_card!.brand}\n${_card!.maskedNumber}',
                                ),
                              ),
                              SettingsRow(
                                title: 'Лицевые счета',
                                subtitle:
                                    '${_accounts.length} счета добавлено',
                                icon: CupertinoIcons.doc_text_fill,
                                iconBackground: AppColors.accountsIconBg,
                                iconColor: AppColors.success,
                                onTap: () => showSimpleInfoSheet(
                                  context,
                                  title: 'Лицевые счета',
                                  message: _accounts.isEmpty
                                      ? 'Счета ещё не добавлены.'
                                      : _accounts
                                          .map(
                                            (a) =>
                                                '${a.title}: ${a.accountNumber}',
                                          )
                                          .join('\n'),
                                ),
                              ),
                              SettingsRow(
                                title: 'Язык',
                                subtitle: _language,
                                icon: CupertinoIcons.globe,
                                iconBackground: AppColors.languageIconBg,
                                iconColor: AppColors.languageIconFg,
                                showSeparator: false,
                                onTap: () => showSimpleInfoSheet(
                                  context,
                                  title: 'Язык',
                                  message:
                                      'Сейчас выбран язык: $_language.\nСмена языка будет доступна после подключения локализации.',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.cardGap),
                        SectionCard(
                          padding: EdgeInsets.zero,
                          backgroundColor: AppColors.dangerSoft
                              .withValues(alpha: 0.55),
                          showShadow: false,
                          child: SettingsRow(
                            title: 'Выйти из аккаунта',
                            subtitle: '',
                            icon: CupertinoIcons.square_arrow_right,
                            iconBackground: AppColors.dangerSoft,
                            iconColor: AppColors.danger,
                            showSeparator: false,
                            isDestructive: true,
                            onTap: _confirmLogout,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
