import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonEntry
    @State private var imageData: Data?
    
    var body: some View {
        VStack {
            
                PokemonImage(imageLink: "\(pokemon.url)")
              
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .background(Circle().stroke(Color.gray.opacity(0.2), lineWidth:4))
                    .padding(.trailing, 20)
          
            Text("Nome: \(pokemon.name.capitalized)")
                .font(.title)
                .padding()

            Text("ID: \(getID(from: pokemon.url))")
                .font(.headline)
                .padding()

            Spacer()
        }
        .navigationBarTitle(Text("Detalhes do Pokémon"), displayMode: .inline)
        .padding()
        .onAppear {
            loadImage()
        }
    }

    // Função para extrair o ID do URL
    private func getID(from url: String) -> String {
        let components = url.split(separator: "/")
        if let idString = components.last {
            return String(idString)
        }
        return ""
    }

    // Função para carregar a imagem do Pokémon
    private func loadImage() {
        guard let imageUrl = URL(string: "https://pokeres.bastionbot.org/images/pokemon/\(getID(from: pokemon.url)).png") else {
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }
}
