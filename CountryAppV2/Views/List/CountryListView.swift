//
//  CountryList.swift
//  CountryAppV2
//
//  Created by Blake McAnally on 6/27/20.
//

import SwiftUI

struct CountryListView: View {
    
    @State
    private var searchText = ""
    
    @FetchRequest(
        entity: Country.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Country.name, ascending: true)
        ]
    )
    public var countries: FetchedResults<Country>
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                List {
                    ForEach(countries.filter({ searchText == "" || $0.name!.uppercased().contains(searchText.uppercased()) }), id: \Country.name) { country in
                        NavigationLink(destination: CountryDetailView(country: country)) {
                            Text(country.name!)
                        }
                    }
                }
                .resignKeyboardOnDragGesture()
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Countries")
        }
    }
}

