import 'package:flutter/material.dart';
import 'package:ifran/helpers/users_helper.dart';

// Écran pour modifier l'emploi du temps
class EditSchedule extends StatefulWidget {
  const EditSchedule({super.key});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

// État de l'écran de modification de l'emploi du temps
class _EditScheduleState extends State<EditSchedule> {
  // Clé pour le formulaire
  final _formKey = GlobalKey<FormState>();

  // Variables pour stocker les valeurs sélectionnées
  String? _selectedDay;
  String? _selectedHour;
  String? _subjectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromRGBO(2, 0, 102, 1.0),
        centerTitle: true,
        title: const Text(
          'Pronote IFRAN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.logout, color: Colors.white, size: 20),
            ),
            onPressed: () async {
              await UsersHelper.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Jour de la semaine',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDay,
                  onChanged: (value) => setState(() => _selectedDay = value),
                  items: [
                    'Lundi',
                    'Mardi',
                    'Mercredi',
                    'Jeudi',
                    'Vendredi',
                  ]
                      .map((day) => DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Choisissez un jour';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Heure',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedHour,
                  onChanged: (value) => setState(() => _selectedHour = value),
                  items: [
                    'Matin',
                    'Soir',
                  ]
                      .map((hour) => DropdownMenuItem<String>(
                            value: hour,
                            child: Text(hour),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Choisissez une séance';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Matière',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _subjectName = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: Save the changes to the schedule
                      print(
                          'Modifications enregistrées: $_selectedDay, $_selectedHour, $_subjectName');
                    }
                  },
                  child: const Text('Modifier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}