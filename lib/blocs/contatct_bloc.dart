import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/repositories/contact_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//bloc
class ContactBloc extends Bloc<ContactEvent, ContactsState> {
  final ContactRepository contactRepository;

  ContactBloc(this.contactRepository) : super(ContactsLoading()) {
    on<FetchContacts>(
      (event, emit) async {
        try {
          final contacts = await contactRepository.getContacts();
          emit(
            ContactsLoaded(
              contacts: contacts,
            ),
          );
        } catch (e) {
          emit(ContactsError());
        }
      },
    );

    on<SearchContacts>((event, emit) {
      final contacts = state is ContactsLoaded
          ? (state as ContactsLoaded).contacts
          : (state as ContactsSearched).contacts;
      final filteredContacts = contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      if (event.query.trim().isEmpty) {
        emit(
          ContactsSearched(
            contacts: contacts,
            filteredContacts: contacts,
          ),
        );
      } else {
        emit(
          ContactsSearched(
            contacts: contacts,
            filteredContacts: filteredContacts,
          ),
        );
      }
    });
  }
}

//events
abstract class ContactEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchContacts extends ContactEvent {}

class SearchContacts extends ContactEvent {
  final String query;

  SearchContacts(this.query);

  @override
  List<Object> get props => [query];
}

//states
abstract class ContactsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<Contact> contacts;

  ContactsLoaded({
    required this.contacts,
  });

@override
  List<Object?> get props => [contacts];
}



class ContactsSearched extends ContactsState {
  final List<Contact> filteredContacts;
  final List<Contact> contacts;

  ContactsSearched({
    required this.contacts,
    required this.filteredContacts,
  });

  @override
  List<Object> get props => [filteredContacts, contacts];
}

class ContactsError extends ContactsState {}



extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) return true;
    if (length != other.length) return false;
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}