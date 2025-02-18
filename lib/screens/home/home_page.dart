import 'package:contacts_app/blocs/contatct_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ContactBloc>().add(FetchContacts());
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: TextField(
              onChanged: (query) {
                context.read<ContactBloc>().add(SearchContacts(query));
              },
              decoration: InputDecoration(
                labelText: "Search Contacts",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ContactBloc, ContactsState>(
              builder: (context, state) {
                print(state);
                if (state is ContactsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ContactsError) {
                  return Center(
                    child: Text('Error loading contacts'),
                  );
                } else if (state is ContactsLoaded || state is ContactsSearched) {
                  final contacts =
                  state is ContactsLoaded ? state.contacts : (state as ContactsSearched).filteredContacts;
                  return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        title: Text(contact.name),
                        subtitle: Text('${contact.phone} | ${contact.email}'),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No contacts Found'),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
