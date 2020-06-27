//
//  CountriesViewModel.swift
//  CountryAppV2
//
//  Created by Blake McAnally on 6/27/20.
//

import Foundation
import CoreData
import Combine
import SwiftUI

public class CountriesViewModel: ObservableObject {
    
    private let persistentContainer: NSPersistentContainer
    
    private let client = CountryAPIClient()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ container: NSPersistentContainer) {
        persistentContainer = container
        fetchCountries(into: persistentContainer)
    }
    
    private func fetchCountries(into container: NSPersistentContainer) {
        client
            .fetchCountries()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { (countries: [CountryAPIClient.Country]) in
                let context = container.viewContext
                countries.forEach { apiCountry in
                    _ = CountriesViewModel.makeCountry(
                        with: context,
                        apiCountry: apiCountry
                    )
                }
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }.store(in: &cancellables)
    }
    
    private static func makeCountry(
        with context: NSManagedObjectContext,
        apiCountry: CountryAPIClient.Country
    ) -> Country {
        let country = Country(context: context)
        country.alpha2Code = apiCountry.alpha2Code
        country.alpha3Code = apiCountry.alpha3Code
        country.area = apiCountry.area ?? 0.0
        
        country.borders = Set(apiCountry.borders.map { string -> Border in
            let border = Border(context: context)
            border.value = string
            return border
        }) as NSSet
        
        country.capital = apiCountry.capital
        country.cioc = apiCountry.cioc
        
        country.currencies = Set(apiCountry.currencies.map { apiCurrency -> Currency in
            let currency = Currency(context: context)
            currency.name = apiCurrency.name
            currency.code = apiCurrency.code
            currency.symbol = apiCurrency.symbol
            return currency
        }) as NSSet
        
        country.demonym = apiCountry.demonym
        country.flag = apiCountry.flag
        country.gini = apiCountry.gini ?? 0.0
        country.languages = Set(apiCountry.languages.map { apiLanguage -> Language in
            let language = Language(context: context)
            language.iso6391 = apiLanguage.iso6391
            language.iso6392 = apiLanguage.iso6392
            language.name = apiLanguage.name
            language.nativeName = apiLanguage.nativeName
            return language
        }) as NSSet
        
        if apiCountry.latlng.count == 2 {
            country.latitude = apiCountry.latlng[0]
            country.longitude = apiCountry.latlng[1]
        }
        
        country.name = apiCountry.name
        country.nativeName = apiCountry.nativeName
        country.numericCode = apiCountry.numericCode
        country.population = Int64(apiCountry.population)
        country.region = apiCountry.region
        
        country.regionalBlocs = Set(apiCountry.regionalBlocs.map { bloc -> RegionalBloc in
            let regionalBloc = RegionalBloc(context: context)
            regionalBloc.acronym = bloc.acronym
            regionalBloc.name = bloc.name
            return regionalBloc
        }) as NSSet
        
        country.subregion = apiCountry.subregion
        country.timezones = Set(apiCountry.timezones.map { zone -> Timezone in
            let timezone = Timezone(context: context)
            timezone.value = zone
            return timezone
        }) as NSSet
        
        let translations = Translations(context: context)
        translations.br = apiCountry.translations.br
        translations.de = apiCountry.translations.de
        translations.es = apiCountry.translations.es
        translations.fa = apiCountry.translations.fa
        translations.fr = apiCountry.translations.fr
        translations.hr = apiCountry.translations.hr
        translations.it = apiCountry.translations.it
        translations.ja = apiCountry.translations.ja
        translations.nl = apiCountry.translations.nl
        translations.pt = apiCountry.translations.pt
        country.translations = translations
        
        return country
    }
}
