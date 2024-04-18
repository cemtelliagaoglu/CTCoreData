//
//  CoreDataManager.swift
//
//
//  Created by Cem Telliagaoglu on 17.04.2024.
//

import Foundation
import CoreData

open class CoreDataManager {
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

    // MARK: - Lifecycle
    
    public init(storageName: String) {
        self.storageName = storageName
    }
    
    //MARK: - Methods

    open func create<E>(type _: E.Type, completion: @escaping ((Result<E, CoreDataError>) -> Void)) {
        do {
            guard let object = NSEntityDescription.insertNewObject(forEntityName: "\(E.self)", into: context) as? E
            else {
                completion(.failure(.create))
                return
            }
            try context.save()
            completion(.success(object))
        } catch {
            completion(.failure(.save))
        }
    }

    open func read<E>(type _: E.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil,
                 completion: @escaping ((Result<[E], CoreDataError>) -> Void))
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(E.self)")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            guard let objects = try context.fetch(fetchRequest) as? [E]
            else {
                completion(.failure(.fetch))
                return
            }
            completion(.success(objects))
        } catch {
            completion(.failure(.read))
        }
    }

    open func update(completion: @escaping ((Result<Void, CoreDataError>) -> Void)) {
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.update))
        }
    }

    open func delete(objects: [NSManagedObject], completion: @escaping ((Result<Void, CoreDataError>) -> Void)) {
        do {
            for object in objects {
                context.delete(object)
            }
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.delete))
        }
    }
}
