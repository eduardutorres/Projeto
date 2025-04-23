import SwiftUI

struct ContactDetailView: View {
    
    let contact: Contact
    
    var body: some View {
        List {
            
            Section("Geral") {
                
                LabeledContent {
                    Text(contact.email)
                } label: {
                    Text("E-mail:")
                }
                    
                LabeledContent {
                    Text(contact.escola)
                } label: {
                    Text("Escola:")
                }
                LabeledContent {
                    Text(contact.phoneNumber)
                } label: {
                    Text("Telefone:")
                }
                
                LabeledContent {
                    Text(contact.dob, style: .date)
                } label: {
                    Text("Admissão:")
                }
            }
            
            Section("Notas") {
                Text(contact.notes)
            }
        }
        .navigationTitle(contact.formattedName)
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactDetailView(contact: .preview())
        }
    }
}
