// lib/models/registrant_model.dart

class Registrant {
  final String id;
  final String name;
  final String email;
  final String gender;
  final String programStudi;
  final DateTime dateOfBirth;
  final DateTime registeredAt;

  Registrant({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.programStudi,
    required this.dateOfBirth,
    DateTime? registeredAt,
  }) : registeredAt = registeredAt ?? DateTime.now();

  Registrant copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    String? programStudi,
    DateTime? dateOfBirth,
    DateTime? registeredAt,
  }) {
    return Registrant(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      programStudi: programStudi ?? this.programStudi,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get formattedDateOfBirth {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dateOfBirth.day} ${months[dateOfBirth.month]} ${dateOfBirth.year}';
  }

  String get formattedRegisteredAt {
    return '${registeredAt.day}/${registeredAt.month}/${registeredAt.year} '
        '${registeredAt.hour.toString().padLeft(2, '0')}:'
        '${registeredAt.minute.toString().padLeft(2, '0')}';
  }
}