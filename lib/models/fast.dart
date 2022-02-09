import 'package:hive/hive.dart';
part 'fast.g.dart';

@HiveType(typeId: 1)
class Fast {
  @HiveField(0)
  final DateTime start;
  @HiveField(1)
  final DateTime end;
  @HiveField(2)
  final Duration targetDuration;

  Fast({
    required this.start,
    required this.end,
    required this.targetDuration,
  });
}
