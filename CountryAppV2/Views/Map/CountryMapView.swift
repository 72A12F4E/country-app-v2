//
//  CountryMapView.swift
//  CountryAppV2
//
//  Created by Blake McAnally on 6/27/20.
//

import SwiftUI
import MapKit

extension Country: Identifiable {
    public var id: String {
        return name ?? ""
    }
}

struct CountryMapView: View {
    
    @State
    private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90)
    )
    
    @FetchRequest(
        entity: Country.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Country.name, ascending: true)
        ]
    )
    public var countries: FetchedResults<Country>
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            showsUserLocation: true,
            annotationItems: countries
        ) { country in
            MapPin(
                coordinate: CLLocationCoordinate2D(
                    latitude: country.latitude,
                    longitude: country.longitude
                )
            )
        }
        .edgesIgnoringSafeArea(.top)
    }
}
