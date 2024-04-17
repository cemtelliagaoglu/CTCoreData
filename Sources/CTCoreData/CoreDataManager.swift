//
//  CoreDataManager.swift
//
//
//  Created by Cem Telliagaoglu on 17.04.2024.
//

import Foundation
import CoreData

final public class CoreDataManager {
    // MARK: - Properties
    
    private let storageName: String

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: storageName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context = persistentContainer.viewContext

    // MARK: - Methods
    
    public init(storageName: String) {
        self.storageName = storageName
    }

    
}
