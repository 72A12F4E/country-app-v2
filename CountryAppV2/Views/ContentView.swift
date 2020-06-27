//
//  ContentView.swift
//  CountryAppV2
//
//  Created by Blake McAnally on 6/25/20.
//

import SwiftUI
import CoreData
import Combine
import MapKit

struct ContentView: View {
    var body: some View {
        TabView {
            CountryListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
            
            CountryMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
    }
}
