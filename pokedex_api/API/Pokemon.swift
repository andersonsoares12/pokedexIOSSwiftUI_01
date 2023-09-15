import Foundation
import SwiftUI

struct Pokemon: Codable {
    var results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable {
    let id = UUID()
    var name: String
    var url: String
}

struct PokemonAbility: Codable {
    var ability: Ability
}

struct Ability: Codable {
    var name: String
}

struct PokemonStat: Codable {
    var base_stat: Int
    var stat: Stat
}

struct Stat: Codable {
    var name: String
}

struct PokemonType: Codable {
    var type: Type
}

struct Type: Codable {
    var name: String
}

class PokeApi {
    func getData(completion: @escaping ([PokemonEntry]) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            let pokemonList = try! JSONDecoder().decode(Pokemon.self, from: data)

            DispatchQueue.main.async {
                completion(pokemonList.results)
            }
        }.resume()
    }
    
    func getAbilities(for url: String, completion: @escaping ([Ability]) -> ()) {
        guard let abilityURL = URL(string: url) else { return }

        URLSession.shared.dataTask(with: abilityURL) { (data, response, error) in
            guard let data = data else { return }

            do {
                let abilityData = try JSONDecoder().decode(PokemonAbility.self, from: data)
                let abilities = [abilityData.ability]

                DispatchQueue.main.async {
                    completion(abilities)
                }
            } catch {
                print("Error decoding abilities data: \(error)")
            }
        }.resume()
    }
    
    func getStats(for url: String, completion: @escaping ([Stat]) -> ()) {
        guard let statURL = URL(string: url) else { return }

        URLSession.shared.dataTask(with: statURL) { (data, response, error) in
            guard let data = data else { return }

            let stats = try! JSONDecoder().decode([Stat].self, from: data)

            DispatchQueue.main.async {
                completion(stats)
            }
        }.resume()
    }
    
    func getTypes(for url: String, completion: @escaping ([Type]) -> ()) {
        guard let typeURL = URL(string: url) else { return }

        URLSession.shared.dataTask(with: typeURL) { (data, response, error) in
            guard let data = data else { return }

            let types = try! JSONDecoder().decode([Type].self, from: data)

            DispatchQueue.main.async {
                completion(types)
            }
        }.resume()
    }
}
