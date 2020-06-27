//
//  CountryAPI.swift
//  CountryApp
//
//  Created by Blake McAnally on 1/2/20.
//  Copyright © 2020 Blake McAnally. All rights reserved.
//

import Foundation
import Combine
import CoreData

class CountryAPIClient: ObservableObject {
    
    func fetchCountries() -> AnyPublisher<[CountryAPIClient.Country], Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://restcountries.eu/rest/v2/all")!)
            .map(\.data)
            .decode(type: [Country].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    struct Country: Codable {
        let name: String
        let topLevelDomain: [String]
        let alpha2Code, alpha3Code: String
        let callingCodes: [String]
        let capital: String
        let altSpellings: [String]
        let region, subregion: String
        let population: Int
        let latlng: [Double]
        let demonym: String
        let area: Double?
        let gini: Double?
        let timezones, borders: [String]
        let nativeName: String
        let numericCode: String?
        let currencies: [Currency]
        let languages: [Language]
        let translations: Translations
        let flag: String
        let regionalBlocs: [RegionalBloc]
        let cioc: String?
    }

    // MARK: - Currency
    struct Currency: Codable {
        let name: String?
        let code: String?
        let symbol: String?
    }

    // MARK: - Language
    struct Language: Codable {
        let iso6391: String?
        let iso6392: String?
        let name: String
        let nativeName: String

        enum CodingKeys: String, CodingKey {
            case iso6391 = "iso639_1"
            case iso6392 = "iso639_2"
            case name
            case nativeName
        }
    }

    // MARK: - RegionalBloc
    struct RegionalBloc: Codable {
        let acronym: String
        let name: String
        let otherAcronyms: [String]
        let otherNames: [String]
    }

    // MARK: - Translations
    struct Translations: Codable {
        let de: String?
        let es: String?
        let fr: String?
        let ja: String?
        let it: String?
        let br: String?
        let pt: String?
        let nl: String?
        let hr: String?
        let fa: String?
    }
}

extension CountryAPIClient.Country: Equatable {
    static func == (lhs: CountryAPIClient.Country, rhs: CountryAPIClient.Country) -> Bool {
        return lhs.name == rhs.name
    }
}

extension CountryAPIClient.Country: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
