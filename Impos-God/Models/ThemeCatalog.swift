//
//  ThemeCatalog.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//


import Foundation

enum ThemeCatalog {
    static let all: [Theme] = [
        Theme(
            name: "Futbolistas top actuales",
            words: ["Mbappé", "Vinicius Jr.", "Bellingham", "Rodrygo", "Valverde", "Courtois", "Lamine Yamal", "Pedri", "Raphinha", "Cubarsí", "Salah", "Haaland", "Cole Palmer", "Bukayo Saka", "Messi", "Luis Suárez", "Sergio Busquets", "Jordi Alba"],
            category: .actualidad
        ),
        Theme(
            name: "Real Madrid 2025/26",
            words: ["Courtois", "Lunin", "Carvajal", "Alaba", "Trent", "Rüdiger", "Fran García", "Bellingham", "Camavinga", "Valverde", "Tchouaméni", "Arda Güler", "Ceballos", "Vinicius Jr.", "Mbappé", "Rodrygo", "Endrick", "Brahim", "Gonzalo", "Mastantuono"],
            category: .actualidad
        ),
        Theme(
            name: "Barça 2025/26",
            words: ["Joan García", "Szczęsny", "Cubarsí", "Gerard Martín", "Marc Bernal", "Gavi", "Christensen", "Pedri", "Dani Olmo", "Fermín", "Lamine Yamal", "Ferran Torres", "Marcus Rashford", "Raphinha", "João Cancelo"],
            category: .actualidad
        ),
        Theme(
            name: "Cantantes España actual",
            words: ["Aitana", "Quevedo", "Lola Índigo", "Bad Gyal", "Ana Mena", "Dani Fernández", "Pablo Alborán", "Walls", "Beret", "Vicco", "Ruslana", "Nil Moliner"],
            category: .actualidad
        ),
        Theme(
            name: "Música latina / urbana actual",
            words: ["Bad Bunny", "Karol G", "Myke Towers", "Rauw Alejandro", "Carín León", "Feid", "Beéle", "Xavi", "Manuel Turizo", "Shakira", "Kenia OS", "Alejandro Sanz"],
            category: .actualidad
        ),
        Theme(
            name: "Fórmula 1 2026",
            words: ["Lewis Hamilton", "Charles Leclerc", "Max Verstappen", "Lando Norris", "Oscar Piastri", "George Russell", "Kimi Antonelli", "Fernando Alonso", "Carlos Sainz", "Sergio Pérez"],
            category: .actualidad
        ),
        Theme(
            name: "NBA actual",
            words: ["Luka Dončić", "Stephen Curry", "Shai Gilgeous-Alexander", "Nikola Jokić", "Victor Wembanyama", "LeBron James", "Kevin Durant", "Anthony Edwards", "Jalen Brunson", "Donovan Mitchell"],
            category: .actualidad
        ),
        Theme(
            name: "UFC / MMA actual",
            words: ["Ilia Topuria", "Islam Makhachev", "Khamzat Chimaev", "Alexander Volkanovski", "Alex Pereira", "Merab Dvalishvili", "Sean O’Malley", "Charles Oliveira"],
            category: .actualidad
        ),
        Theme(
            name: "Streamers hispanos actuales",
            words: ["ibai", "IlloJuan", "Rubius", "Auronplay", "Mixwell", "knekro", "ElMariana"],
            category: .actualidad
        ),
        Theme(
            name: "Política española actual",
            words: ["Pedro Sánchez", "Alberto Núñez Feijóo", "Santiago Abascal", "Isabel Díaz Ayuso", "Yolanda Díaz", "José Luis Martínez-Almeida", "Gabriel Rufián", "Irene Montero", "Ione Belarra", "Carles Puigdemont"],
            category: .actualidad
        ),
        Theme(
            name: "La que se avecina - personajes",
            words: ["Amador Rivas", "Coque Calatrava", "Maite Figueroa", "Antonio Recio", "Berta Escobar", "Rebeca Ortiz", "Agustín Gordillo", "Cristina", "Martín", "Chusa"],
            category: .series
        ),
        Theme(
            name: "La que se avecina - actores",
            words: ["Pablo Chiapella", "Nacho Guerreros", "Eva Isanta", "Jordi Sánchez", "Nathalie Seseña", "María Adánez", "Ana Arias", "Raúl Peña", "Paz Padilla", "Carlos Areces", "Mamen García"],
            category: .series
        ),
        Theme(
            name: "Harry Potter",
            words: ["Harry Potter", "Hermione Granger", "Ron Weasley", "Draco Malfoy", "Albus Dumbledore", "Severus Snape", "Voldemort", "Sirius Black", "Luna Lovegood", "Hagrid"],
            category: .series
        ),
        Theme(
            name: "Marvel",
            words: ["Iron Man", "Spider-Man", "Captain America", "Thor", "Hulk", "Black Widow", "Doctor Strange", "Wolverine", "Deadpool", "Thanos"],
            category: .series
        ),
        Theme(
            name: "Disney",
            words: ["Mickey Mouse", "Elsa", "Simba", "Aladdín", "Ariel", "Mulán", "Buzz Lightyear", "Woody", "Rapunzel", "Stitch"],
            category: .series
        ),
        Theme(
            name: "Pokémon",
            words: ["Pikachu", "Charizard", "Bulbasaur", "Squirtle", "Mewtwo", "Snorlax", "Gengar", "Eevee", "Lucario", "Jigglypuff"],
            category: .series
        ),
        Theme(
            name: "Dragon Ball",
            words: ["Goku", "Vegeta", "Gohan", "Piccolo", "Freezer", "Trunks", "Krillin", "Bulma", "Broly", "Beerus"],
            category: .series
        ),
        Theme(
            name: "Naruto",
            words: ["Naruto Uzumaki", "Sasuke Uchiha", "Sakura Haruno", "Kakashi Hatake", "Itachi Uchiha", "Gaara", "Hinata Hyuga", "Jiraiya", "Pain", "Madara Uchiha"],
            category: .series
        ),
        Theme(
            name: "One Piece",
            words: ["Luffy", "Zoro", "Nami", "Sanji", "Usopp", "Chopper", "Robin", "Ace", "Shanks", "Trafalgar Law"],
            category: .series
        ),
        Theme(
            name: "GTA",
            words: ["CJ", "Tommy Vercetti", "Niko Bellic", "Michael De Santa", "Franklin Clinton", "Trevor Philips", "Lester", "Big Smoke"],
            category: .series
        ),
        Theme(
            name: "The Last of Us",
            words: ["Joel", "Ellie", "Abby", "Tommy", "Tess", "Marlene", "Bill", "Dina"],
            category: .series
        ),
        Theme(
            name: "Stranger Things",
            words: ["Eleven", "Mike", "Dustin", "Lucas", "Will", "Max", "Hopper", "Steve", "Nancy", "Vecna"],
            category: .series
        ),
        Theme(
            name: "Breaking Bad",
            words: ["Walter White", "Jesse Pinkman", "Saul Goodman", "Gus Fring", "Skyler White", "Hank Schrader", "Mike Ehrmantraut"],
            category: .series
        ),
        Theme(
            name: "Friends",
            words: ["Rachel", "Ross", "Monica", "Chandler", "Joey", "Phoebe"],
            category: .series
        ),
        Theme(
            name: "Los Simpson",
            words: ["Homer", "Marge", "Bart", "Lisa", "Maggie", "Ned Flanders", "Mr. Burns", "Moe"],
            category: .series
        ),
        Theme(
            name: "Call of Duty",
            words: ["Ghost", "Soap", "Price", "Makarov", "Zombies", "Warzone", "Verdansk", "Task Force 141"],
            category: .series
        ),
        Theme(
            name: "Fortnite",
            words: ["Battle Bus", "Victory Royale", "Jonesy", "Tilted Towers", "Loot Lake", "Peely", "Llama", "Travis Scott"],
            category: .series
        ),
        Theme(
            name: "Minecraft",
            words: ["Steve", "Creeper", "Enderman", "Diamante", "Redstone", "Nether", "Aldea", "Zombie"],
            category: .series
        ),
        Theme(
            name: "Operación Triunfo",
            words: ["Academia", "Gala", "Nominado", "Triunfito", "Noemí Galera", "Chenoa", "Amaia", "Aitana", "Alfred", "Cepeda"],
            category: .series
        ),
        Theme(
            name: "La isla de las tentaciones",
            words: ["Sandra Barneda", "Villa Playa", "Villa Montaña", "Tentación", "Hoguera", "Infidelidad", "Tentador", "Pareja"],
            category: .series
        ),
        Theme(
            name: "Comida rápida",
            words: ["Pizza", "Hamburguesa", "Hot dog", "Kebab", "Tacos", "Burrito", "Nuggets", "Patatas fritas", "Sándwich", "Donut"],
            category: .general
        ),
        Theme(
            name: "Ciudades de España",
            words: ["Madrid", "Barcelona", "Sevilla", "Valencia", "Córdoba", "Málaga", "Bilbao", "Granada", "Zaragoza", "Alicante"],
            category: .general
        ),
        Theme(
            name: "Países del mundo",
            words: ["España", "Francia", "Italia", "Alemania", "Japón", "Brasil", "Argentina", "México", "Estados Unidos", "Portugal"],
            category: .general
        ),
        Theme(
            name: "Monumentos famosos",
            words: ["Torre Eiffel", "Coliseo", "Big Ben", "Sagrada Familia", "Estatua de la Libertad", "Taj Mahal", "Machu Picchu", "Pirámides de Egipto"],
            category: .general
        ),
        Theme(
            name: "Profesiones",
            words: ["Médico", "Profesor", "Ingeniero", "Abogado", "Bombero", "Arquitecto", "Chef", "Piloto", "Policía", "Dentista"],
            category: .general
        ),
        Theme(
            name: "Animales marinos",
            words: ["Tiburón", "Delfín", "Pulpo", "Ballena", "Caballito de mar", "Foca", "Medusa", "Manta raya", "Orca", "Cangrejo"],
            category: .general
        ),
        Theme(
            name: "Marcas de ropa",
            words: ["Nike", "Adidas", "Zara", "Pull&Bear", "Balenciaga", "Gucci", "Puma", "Lacoste", "Levi's", "New Balance"],
            category: .general
        ),
        Theme(
            name: "Marcas de coches",
            words: ["Ferrari", "BMW", "Mercedes", "Audi", "Toyota", "Tesla", "Porsche", "Lamborghini", "Seat", "Volkswagen"],
            category: .general
        ),
        Theme(
            name: "Memes de internet",
            words: ["Doge", "Pepe the Frog", "Woman Yelling at a Cat", "This Is Fine", "Drakeposting", "Gigachad", "Trollface"],
            category: .general
        )
    ]
}
