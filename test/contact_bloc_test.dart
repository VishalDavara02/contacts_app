import 'package:contacts_app/blocs/contatct_bloc.dart';
import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/repositories/contact_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

List<Contact> mockContacts = [
  Contact(name: 'Test', phone: '+1 239023904', email: 'test@wmail.com'),
  Contact(name: 'Bloc', phone: '+1 239123904', email: 'bloc@wmail.com'),
  Contact(name: 'Dart', phone: '+1 239223904', email: 'dart@wmail.com'),
  Contact(name: 'Flutter', phone: '+1 239323904', email: 'flutter@wmail.com'),
];

class ContactRepositoryMock extends ContactRepository {
  final Future<List<Contact>> Function() returnCallback;

  ContactRepositoryMock(this.returnCallback);

  @override
  Future<List<Contact>> getContacts() async {
    final contacts = await returnCallback();
    return contacts;
  }
}

void main() {
  blocTest<ContactBloc, ContactsState>(
    'Check if initial state is ContactsLoading',
    build: () => ContactBloc(
      ContactRepositoryMock(
        () => Future.delayed(
          const Duration(seconds: 0),
          () => mockContacts,
        ),
      ),
    ),
    verify: (bloc) => expect(
      bloc.state,
      ContactsLoading(),
    ),
  );

  blocTest<ContactBloc, ContactsState>(
    'Check for successful response',
    build: () => ContactBloc(
      ContactRepositoryMock(
        () => Future.value(mockContacts),
      ),
    ),
    act: (bloc) => bloc.add(FetchContacts()),
    expect: () => [ContactsLoaded(contacts: mockContacts)],
  );

  blocTest<ContactBloc, ContactsState>(
    'Check for error',
    build: () => ContactBloc(
      ContactRepositoryMock(
        () => Future.error('Error'),
      ),
    ),
    act: (bloc) => bloc.add(FetchContacts()),
    expect: () => [ContactsError()],
  );

  blocTest<ContactBloc, ContactsState>(
    'Check for Search response',
    build: () => ContactBloc(
      ContactRepositoryMock(
        () => Future.value(mockContacts),
      ),
    ),
    act: (bloc) {
      bloc.add(FetchContacts());
      bloc.add(SearchContacts('Test'));
    },
    expect: () => [
      ContactsLoaded(contacts: mockContacts),
      ContactsSearched(
        contacts: mockContacts,
        filteredContacts: [
          Contact(name: 'Test', phone: '+1 239023904', email: 'test@wmail.com')
        ],
      )
    ],
  );
}
