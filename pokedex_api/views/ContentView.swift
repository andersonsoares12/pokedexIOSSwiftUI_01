import SwiftUI

struct ContentView: View {
    @State var pokemon = [PokemonEntry]()
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchText == "" ? pokemon : pokemon.filter({ $0.name.contains(searchText.lowercased()) })) { entry in
                    NavigationLink(destination: PokemonDetailView(pokemon: entry)) { // Alteração aqui
                        HStack {
                            PokemonImage(imageLink: "\(entry.url)")
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .background(Circle().fill(Color.gray.opacity(0.2)))
                                .padding(.trailing, 20)
                            
                            Text("\(entry.name)".capitalized)
                        }
                    }
                }
            }
            .onAppear {
                PokeApi().getData() { pokemon in
                    self.pokemon = pokemon
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("PokedexUI")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
