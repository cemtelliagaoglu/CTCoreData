//
//  CoreDataManager.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 22.04.2024.
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
        number: String,
        completion: @escaping((Result<Void, CoreDataError>) -> Void)
    ) {
        create(type: Person.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(person):
                person.name = name
                person.number = number
                self.update(completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchContacts(
        by searchText: String?,
        isAscending: Bool,
        completion: @escaping((Result<[Person], CoreDataError>) -> Void)
    ) {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: isAscending)
        var predicate: NSPredicate? = nil
        if let searchText,
           !searchText.isEmpty {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        read(type: Person.self, predicate: predicate, sortDescriptors: [sortDescriptor], completion: completion) 
    }
}
