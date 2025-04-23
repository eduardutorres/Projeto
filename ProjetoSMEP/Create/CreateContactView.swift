import SwiftUI

struct CreateContactView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: EditContactViewModel
    
    @State private var hasError: Bool = false

       var body: some View {
           List {
               
               Section("Geral") {
                  
                   TextField("Nome", text: $vm.contact.name)
                                       .keyboardType(.namePhonePad)
                   
                   TextField("Escola", text: $vm.contact.escola)
                       .keyboardType(.default)
                   
                   TextField("E-mail", text: $vm.contact.email)
                       .keyboardType(.emailAddress)

                   TextField("Telefone", text: $vm.contact.phoneNumber)
                       .keyboardType(.phonePad)

                   DatePicker("Admissão",
                              selection: $vm.contact.dob,
                              displayedComponents: [.date])
                   .datePickerStyle(.compact)
                   
                   Toggle("Favoritar", isOn: $vm.contact.isFavourite)
                   
               }
               
               Section("Notas") {
                   TextField("",
                             text: $vm.contact.notes,
                             axis: .vertical)
               }
           }
           .navigationTitle(vm.isNew ? "Novo Contratado(a)" : "Editar Dados")
           .toolbar {
               ToolbarItem(placement: .confirmationAction) {
                   Button("Ok") {
                       validate()
                   }
               }
               
               ToolbarItem(placement: .navigationBarLeading) {
                   Button("Cancelar") {
                       dismiss()
                   }
               }
           }
           .alert("Algo deu errado...",
           isPresented: $hasError,
                  actions: {}) {
               Text("Verifique se os dados estão corretos")
           }
           
       }
}

private extension CreateContactView {
    
    func validate() {
        if vm.contact.isValid {
            do {
                try vm.save()
                dismiss()
            } catch {
                print(error)
            }
        } else {
            hasError = true
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let preview = ContactsProvider.shared
            CreateContactView(vm: .init(provider: preview))
                .environment(\.managedObjectContext, preview.viewContext)
        }
    }
}
