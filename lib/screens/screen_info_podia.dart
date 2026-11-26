import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/dq_theme.dart';
import '../widgets/common.dart';

class Podium {
  const Podium({required this.id, required this.naam, this.lat, this.lon});

  factory Podium.fromJson(Map<String, dynamic> json) {
    return Podium(
      id: json['id'] as int,
      naam: json['naam'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );
  }

  final int id;
  final String naam;
  final double? lat;
  final double? lon;
}

class ScreenInfoPodia extends StatefulWidget {
  const ScreenInfoPodia({super.key});

  @override
  State<ScreenInfoPodia> createState() => _ScreenInfoPodiaState();
}

class _ScreenInfoPodiaState extends State<ScreenInfoPodia> {
  static const _apiUrl =
      'https://func-festival-api.azurewebsites.net/api/podia';

  List<Podium> _podia = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPodia();
  }

  Future<void> _loadPodia() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw Exception('API returned status ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw Exception('API returned an unexpected format');
      }

      final podia = decoded
          .whereType<Map<String, dynamic>>()
          .map(Podium.fromJson)
          .toList();

      if (mounted) {
        setState(() {
          _podia = podia;
          _loading = false;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Stages konden niet worden geladen: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DQ.ink,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeading(kicker: 'FESTIVAL GROUNDMAP', title: 'STAGES'),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: DQ.red)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _error!,
                      style: inter(11, weight: FontWeight.w700, color: DQ.red),
                    ),
                    const SizedBox(height: 12),
                    Tap(
                      onTap: _loadPodia,
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        color: DQ.red,
                        child: Text(
                          'OPNIEUW PROBEREN',
                          style: inter(9, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              for (final podium in _podia)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: DQ.dark,
                    border: Border.all(color: DQ.line),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        color: DQ.red,
                        child: Text(
                          podium.id.toString().padLeft(2, '0'),
                          style: bc(16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              podium.naam,
                              style: bc(22, color: Colors.white),
                            ),
                            if (podium.lat != null && podium.lon != null)
                              Text(
                                '${podium.lat!.toStringAsFixed(6)}, ${podium.lon!.toStringAsFixed(6)}',
                                style: inter(
                                  8,
                                  weight: FontWeight.w500,
                                  color: DQ.muted,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
