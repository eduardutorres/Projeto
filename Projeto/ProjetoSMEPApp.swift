import SwiftUI

@main
struct ProjetoSMEPApp: App {
    let provider = ContactsProvider.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, provider.viewContext) 
        }
    }
}
