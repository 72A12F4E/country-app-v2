//
//  CountryDetailView.swift
//  CountryAppV2
//
//  Created by Blake McAnally on 6/27/20.
//

import SwiftUI
import MapKit

struct CountryDetailRow: View {
    let title: String
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.body)
            Text(detail).font(.caption2)
        }
    }
}

struct CountryDetailView: View {
    let country: Country
    
    @State
    private var region = {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 0,
                longitude: 0
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 50,
                longitudeDelta: 50
            )
        )
    }()
    
    var body: some View {
        List {
            Section(header: Text("General")) {
                CountryDetailRow(
                    title: country.nativeName!,
                    detail: "Native Name"
                )
                CountryDetailRow(
                    title: country.capital!,
                    detail: "Capital"
                )
                CountryDetailRow(
                    title: numberFormatter.string(
                        from: NSNumber(value: country.population)
                    ) ?? "",
                    detail: "Population"
                )
                
            }
            
            Section(header: Text("Location")) {
                Map(
                    coordinateRegion: $region,
                    interactionModes: MapInteractionModes(rawValue: 0),
                    annotationItems: [country]
                ) { country in
                    MapPin(
                        coordinate: CLLocationCoordinate2D(
                            latitude: country.latitude,
                            longitude: country.longitude
                        )
                    )
                }
                .cornerRadius(8.0)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .frame(idealWidth: 250, idealHeight: 250)
                .onAppear {
                    withAnimation {
                        updateRegion()
                    }
                }
                CountryDetailRow(
                    title: country.region!,
                    detail: "Region"
                )
                CountryDetailRow(
                    title: country.subregion!,
                    detail: "Subegion"
                )
                CountryDetailRow(
                    title: formatArea(country.area),
                    detail: "Area"
                )
            }
            
            Section(header: Text("Misc")) {
                CountryDetailRow(
                    title: country.alpha2Code!,
                    detail: "Alpha 2 Code"
                )
                CountryDetailRow(
                    title: country.alpha3Code!,
                    detail: "Alpha 3 Code"
                )
                CountryDetailRow(
                    title: country.gini == 0 ? "Unknown" : "\(country.gini)",
                    detail: "GINI Index"
                )
            }
        }
        .navigationBarTitle(country.name!, displayMode: .inline)
        .listStyle(InsetGroupedListStyle())
    }
    
    private func updateRegion() {
        let delta = 40.0
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: country.latitude,
                longitude: country.longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: delta,
                longitudeDelta: delta
            )
        )
    }
    
    @State
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private func formatArea(_ area: Double) -> String {
        let formatter = MeasurementFormatter()
        let kmSquared = Measurement(
            value: area,
            unit: UnitArea.squareKilometers
        )
        formatter.locale = .current
        return formatter.string(from: kmSquared)
    }
}

