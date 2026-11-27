import 'package:flutter/material.dart';
import '../data/taal.dart';
import '../data/weer.dart';
import '../theme/dq_theme.dart';
import '../widgets/chrome.dart';
import '../widgets/common.dart';
import '../widgets/live.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
    required this.onStart,
    required this.onOpenPodia,
  });

  final VoidCallback onStart;
  final VoidCallback onOpenPodia;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final titleSize = (width * 0.18).clamp(58.0, 90.0);
    final title = bc(
      titleSize,
      italic: true,
      height: 0.82,
      spacing: -3,
      shadows: const [Shadow(offset: Offset(4, 4))],
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: DQ.dark),
        const GreyImage('assets/images/defqon-fireworks.jpg', contrast: 1.3),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x33000000), Color(0xFF0A0A0A)],
              stops: [0.05, 0.78],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x3DFF2134), Colors.transparent],
              stops: [0, 0.65],
            ),
          ),
        ),
        Positioned(
          left: 17,
          top: 22 + pad.top,
          width: 240,
          child: const Brand(showSub: true, center: false),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(17, 24, 17, 34 + pad.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DEFQON.1 · BIDDINGHUIZEN',
                  style: inter(8, color: DQ.lime, spacing: 1.8),
                ),
                const SizedBox(height: 9),
                Text('YOUR LIVE', style: title),
                OutlineText('FESTIVAL', style: title.copyWith(shadows: [])),
                Text('COMPANION', style: title),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Text(
                    t(
                      'Alles wat je vandaag nodig hebt. Live schema, drukte, routes, waarschuwingen en je crew.',
                    ),
                    style: inter(
                      11,
                      weight: FontWeight.w500,
                      color: const Color(0xFFAAAAAA),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF555555)),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _StatusCell(
                            leading: Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: DQ.lime,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: 'TERREIN OPEN',
                            sub: 'Updates zijn live',
                          ),
                        ),
                        Container(width: 1, color: const Color(0xFF555555)),
                        Expanded(
                          child: ValueListenableBuilder<Weer?>(
                            valueListenable: Weer.huidig,
                            builder: (_, weer, _) => _StatusCell(
                              leading: const WeerIcoon(
                                size: 18,
                                color: DQ.yellow,
                              ),
                              title: weer?.temperatuur ?? '–°C',
                              sub: weer?.verwachting ?? t('Weer laden...'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Tap(
                  onTap: onOpenPodia,
                  child: Container(
                    height: 54,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: DQ.dark,
                      border: Border.all(color: DQ.red),
                    ),
                    child: Row(
                      children: [
                        const DqIcon('Stages', color: DQ.red),
                        const SizedBox(width: 10),
                        Text(
                          t('BEKIJK STAGES'),
                          style: inter(10, color: Colors.white),
                        ),
                        const Spacer(),
                        const DqIcon('Pijl_rechts', color: DQ.red),
                      ],
                    ),
                  ),
                ),
                Tap(
                  onTap: onStart,
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: DQ.red,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF68101A),
                          offset: Offset(8, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          t('NAAR HET FESTIVAL'),
                          style: inter(10, color: Colors.white),
                        ),
                        const Spacer(),
                        const DqIcon('Pijl_rechts', color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({
    required this.leading,
    required this.title,
    required this.sub,
  });

  final Widget leading;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 65),
    padding: const EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leading,
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t(title), style: bc(15)),
              Text(
                t(sub),
                style: inter(7, weight: FontWeight.w500, color: DQ.muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
