// lib/pages/registration_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registrant_model.dart';
import '../providers/registration_provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedGender = 'Laki-laki';
  String? _selectedProdi;
  DateTime? _selectedDate;
  bool _agreeTerms = false;

  int _currentStep = 0;
  bool _isEditMode = false;
  String? _editingId;
  bool _isInitialized = false;

  final List<String> _prodiList = const [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Data Science',
    'Desain Komunikasi Visual',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;
    _isInitialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is String) {
      final provider = context.read<RegistrationProvider>();
      final registrant = provider.getById(args);

      if (registrant != null) {
        _isEditMode = true;
        _editingId = registrant.id;
        _nameController.text = registrant.name;
        _emailController.text = registrant.email;
        _passwordController.text = 'password123';
        _selectedGender = registrant.gender;
        _selectedProdi = registrant.programStudi;
        _selectedDate = registrant.dateOfBirth;
        _dateController.text = _formatDate(registrant.dateOfBirth);
        _agreeTerms = true;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2004, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _dateController.clear();

    setState(() {
      _obscurePassword = true;
      _selectedGender = 'Laki-laki';
      _selectedProdi = null;
      _selectedDate = null;
      _agreeTerms = false;
      _currentStep = 0;
      _isEditMode = false;
      _editingId = null;
      _isInitialized = true;
    });
  }

  bool _validateStepOne() {
    final nameValid = _nameController.text.trim().length >= 3;

    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    final emailValid = email.isNotEmpty && emailRegex.hasMatch(email);

    final passwordValid = _passwordController.text.length >= 8;

    return nameValid && emailValid && passwordValid;
  }

  bool _validateStepTwo() {
    return _selectedProdi != null &&
        _selectedDate != null &&
        _agreeTerms == true &&
        _selectedGender.isNotEmpty;
  }

  void _nextStep() {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.validate();

    if (_currentStep == 0) {
      if (_validateStepOne()) {
        setState(() => _currentStep = 1);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lengkapi data di langkah 1 terlebih dahulu'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_currentStep == 1) {
      if (_validateStepTwo()) {
        _submitForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lengkapi data di langkah 2 terlebih dahulu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitForm() {
    final provider = context.read<RegistrationProvider>();

    try {
      if (!_formKey.currentState!.validate()) return;

      if (!_agreeTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap setujui syarat & ketentuan'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedProdi == null || _selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Program studi dan tanggal lahir wajib diisi'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final email = _emailController.text.trim();

      if (provider.isEmailRegistered(email, excludeId: _editingId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email sudah terdaftar'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_isEditMode && _editingId != null) {
        final oldData = provider.getById(_editingId!);
        if (oldData == null) {
          throw Exception('Data yang akan diedit tidak ditemukan');
        }

        final updatedRegistrant = oldData.copyWith(
          name: _nameController.text.trim(),
          email: email,
          gender: _selectedGender,
          programStudi: _selectedProdi,
          dateOfBirth: _selectedDate,
        );

        provider.updateRegistrant(updatedRegistrant);

        _resetForm();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.edit_note, color: Colors.blue, size: 48),
            title: const Text('Update Berhasil'),
            content: Text('${updatedRegistrant.name} berhasil diperbarui.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tutup'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/list');
                },
                child: const Text('Lihat Daftar'),
              ),
            ],
          ),
        );

        return;
      }

      final registrant = Registrant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: email,
        gender: _selectedGender,
        programStudi: _selectedProdi!,
        dateOfBirth: _selectedDate!,
      );

      provider.addRegistrant(registrant);

      _resetForm();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('Registrasi Berhasil'),
          content: Text('${registrant.name} berhasil didaftarkan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/list');
              },
              child: const Text('Lihat Daftar'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Step _buildStepOne() {
    return Step(
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      title: const Text('Data Akun'),
      subtitle: const Text('Nama, email, password'),
      content: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap *',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama wajib diisi';
              }
              if (value.trim().length < 3) {
                return 'Nama minimal 3 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
              hintText: 'nama@email.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email wajib diisi';
              }
              final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password *',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password wajib diisi';
              }
              if (value.length < 8) {
                return 'Password minimal 8 karakter';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Step _buildStepTwo() {
    return Step(
      isActive: _currentStep >= 1,
      state: StepState.indexed,
      title: const Text('Data Pendaftaran'),
      subtitle: const Text('Gender, prodi, tanggal lahir'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Kelamin *',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Laki-laki'),
                  value: 'Laki-laki',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() => _selectedGender = value!);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Perempuan'),
                  value: 'Perempuan',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() => _selectedGender = value!);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedProdi,
            decoration: const InputDecoration(
              labelText: 'Program Studi *',
              prefixIcon: Icon(Icons.school),
              border: OutlineInputBorder(),
            ),
            hint: const Text('Pilih Program Studi'),
            items: _prodiList.map((prodi) {
              return DropdownMenuItem(
                value: prodi,
                child: Text(prodi),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedProdi = value);
            },
            validator: (value) {
              if (value == null) return 'Pilih program studi';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Tanggal Lahir *',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onTap: _pickDate,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal lahir wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Saya setuju dengan syarat & ketentuan *'),
            subtitle: const Text('Wajib dicentang'),
            value: _agreeTerms,
            onChanged: (value) {
              setState(() => _agreeTerms = value ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditMode ? 'Edit Pendaftar' : 'Registrasi Event';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Consumer<RegistrationProvider>(
            builder: (context, provider, child) {
              return Badge(
                label: Text('${provider.count}'),
                isLabelVisible: provider.count > 0,
                child: IconButton(
                  icon: const Icon(Icons.people),
                  onPressed: () => Navigator.pushNamed(context, '/list'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditMode ? '✏️ Edit Data Pendaftar' : '📝 Form Pendaftaran',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isEditMode
                    ? 'Perbarui data pendaftar melalui stepper di bawah ini'
                    : 'Isi semua field yang bertanda (*)',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Stepper(
                currentStep: _currentStep,
                onStepTapped: (step) {
                  setState(() => _currentStep = step);
                },
                onStepContinue: _nextStep,
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  }
                },
                controlsBuilder: (context, details) {
                  final isLastStep = _currentStep == 1;

                  return Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: details.onStepContinue,
                        icon: Icon(isLastStep ? Icons.save : Icons.arrow_forward),
                        label: Text(
                          isLastStep
                              ? (_isEditMode ? 'UPDATE' : 'SUBMIT')
                              : 'LANJUT',
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_currentStep > 0)
                        OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('KEMBALI'),
                        ),
                    ],
                  );
                },
                steps: [
                  _buildStepOne(),
                  _buildStepTwo(),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _resetForm,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}