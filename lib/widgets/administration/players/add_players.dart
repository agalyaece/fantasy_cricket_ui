import 'package:fc_ui/backend_config/config.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPlayers extends StatefulWidget {
  const AddPlayers({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AddPlayerState();
  }
}

class _AddPlayerState extends State<AddPlayers> {
  final _formKey = GlobalKey<FormState>();
  final dropDownKey = GlobalKey<DropdownSearchState>();

  var _enteredPlayerName = "";
  var _enteredPlayerShortName = "";
  String? _selectedCountryCode;
  var _isSending = false;

  void _addPlayers() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      try {
        final url = Uri.parse(addPlayerUrl);
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "player_name": _enteredPlayerName,
            "player_short_name": _enteredPlayerShortName,
            "nationality": _selectedCountryCode,
          }),
        );
        print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newItem = json.decode(response.body);
          Navigator.pop(context, newItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                json.decode(response.body)['message'] ??
                    'Player Added successfully',
              ),
            ),
          );
        } else {
          setState(() {
            _isSending = false;
          });
        }
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add player')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("add player")),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7, // Added width
          margin: const EdgeInsets.all(20), // Added margin
          padding: const EdgeInsets.all(16), // Added padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // boxShadow: [
            //   BoxShadow(
            //     color: Theme.of(context).colorScheme.onPrimary,
            //     blurRadius: 10,
            //     spreadRadius: 5,
            //     offset: const Offset(0, 7),
            //   ),
            // ],
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              width: 2,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Added to fit content
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: "Player Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter valid characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPlayerName = value!;
                  },
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),

                const SizedBox(height: 20),
                DropdownSearch<String>(
                  key: dropDownKey,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountryCode = newValue;
                    });
                  },
                  selectedItem: _selectedCountryCode,
                  items: (filter, infiniteScrollProps) {
                    List<String> filteredList =
                        countryList
                            .where((country) {
                              bool nameMatch = country.name
                                  .toLowerCase()
                                  .contains(filter.toLowerCase());
                              bool codeMatch = country.countryCode
                                  .toLowerCase()
                                  .contains(filter.toLowerCase());
                              return nameMatch || codeMatch;
                            })
                            .map((country) => country.name)
                            .toList();
                    return filteredList;
                  },
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Select Nationality',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    constraints: BoxConstraints(),
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(hintText: "Search Country"),
                    ),
                    itemBuilder: (context, item, isSelected, showSearchBox) {
                      final country = countryList.firstWhere(
                        (element) => element.name == item,
                      );
                      return ListTile(
                        title: Text('${country.name} (${country.countryCode})'),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Player Short Name',
                    hintText: "Short Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter valid characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPlayerShortName = value!;
                  },
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed:
                          _isSending
                              ? null
                              : () {
                                _formKey.currentState!.reset();
                                dropDownKey.currentState!.clear();

                                setState(() {
                                  _selectedCountryCode = null;
                                });
                              },
                      child: const Text("Reset"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isSending ? null : _addPlayers,
                      child:
                          _isSending
                              ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                              : const Text('Add Player'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Country> get countryList {
    return CountryService().getAll();
  }
}


  // Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: FractionallySizedBox(
  //                   widthFactor: 0.5,
  //                   child: