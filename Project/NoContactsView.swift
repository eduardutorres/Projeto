import SwiftUI

struct NoContactsView: View {
    var body: some View {
        VStack {
            Text("👀 Sem Registros")
                .font(.largeTitle.bold())
            Text("Parece um pouco vazio aqui, crie alguns contatos☝️")
                .font(.callout)
        }
    }
}

struct NoContactView_Previews: PreviewProvider {
    static var previews: some View {
        NoContactsView()
    }
}
