//
//  CoreDataManager.swift
//  SampleProjectAsyncAwait
//
//  Created by Cem Telliagaoglu on 12.05.2024.
//

import Foundation
import CTCoreData

final class CoreDataManager: CTCoreDataManager {
    //MARK: - Properties
    
    static let shared = CoreDataManager()
    
    //MARK: - Lifecycle
    
    override private init() {
        super.init(storageName: "DataModel")
    }
    
    //MARK: - Methods
    
    func createNewContact(
        name: String,
        number: String
    ) async throws {
        do {
            let person = try await create(type: Person.self)
            person.name = name
            person.number = number
            try await update()
        } catch {
            throw error
        }
    }
    
    func fetchContacts(
        by searchText: String?,
        isAscending: Bool
    ) async throws -> [Person] {
        do {
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: isAscending)
            var predicate: NSPredicate? = nil
            if let searchText,
               !searchText.isEmpty {
                predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            }
            let contacts = try await read(type: Person.self, predicate: predicate, sortDescriptors: [sortDescriptor])
            return contacts
        } catch {
            throw error
        }
    }
}
