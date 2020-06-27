//
//  CountryAppV2App.swift
//  CountryAppV2
//
//  Created by Blake McAnally on 6/25/20.
//

import SwiftUI
import CoreData
import Combine

@main
struct CountryAppV2App: App {
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Countries")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                fatalError("\(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .environmentObject(CountriesViewModel(persistentContainer))
        }
    }
}


