import SwiftUI

struct SearchConfig: Equatable {
    enum Filter {
        case all, fave
    }
    
    var query: String = ""
    var filter: Filter = .all
}

struct ContentView: View {
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    @State private var contactToEdit: Contact?
    @State private var searchConfig: SearchConfig = .init()
    var provider = ContactsProvider.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    NoContactsView()
                } else {
                    List {
                        ForEach(contacts) { contact in
                            ZStack(alignment: .leading) {
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                ContactRowView(contact: contact, provider: provider)
                                    .swipeActions(allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            do {
                                                try provider.delete(contact, in: provider.newContext)
                                            } catch {
                                                print(error)
                                            }
                                        } label: {
                                            Label("Deletar", systemImage: "trash")
                                        }
                                        .tint(.red)
                                        
                                        Button {
                                            contactToEdit = contact
                                        } label: {
                                            Label("Editar", systemImage: "pencil")
                                        }
                                        .tint(.orange)
                                    }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchConfig.query)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        contactToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        // Header
                        Text("Filtrar")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        // Filter Picker
                        Picker("", selection: $searchConfig.filter) {
                            Label("Todos os Contatos", systemImage: "person.2")
                                .tag(SearchConfig.Filter.all)
                            Label("Favoritos", systemImage: "star")
                                .tag(SearchConfig.Filter.fave)
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Label("Filtrar", systemImage: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(item: $contactToEdit, onDismiss: {
                contactToEdit = nil
            }, content: { contact in
                NavigationStack {
                    CreateContactView(vm: .init(provider: provider, contact: contact))
                }
            })
            .navigationTitle("Contratados")
            .onChange(of: searchConfig) { newConfig in
                contacts.nsPredicate = Contact.filter(with: newConfig)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let preview = ContactsProvider.shared
        ContentView(provider: preview)
            .environment(\.managedObjectContext, preview.viewContext)
            .previewDisplayName("Com Registros")
            .onAppear { Contact.makePreview(count: 10, in: preview.viewContext) }
        
        let emptyPreview = ContactsProvider.shared
        ContentView(provider: emptyPreview)
            .environment(\.managedObjectContext, emptyPreview.viewContext)
            .previewDisplayName("Sem Registros")
    }
}
