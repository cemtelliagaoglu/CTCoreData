//
//  CTCoreDataManager.swift
//
//
//  Created by Cem Telliagaoglu on 17.04.2024.
//

import UIKit
import CoreData

open class CTCoreDataManager {
    // MARK: - Properties
    
    open var storageName: String?

    private lazy var persistentContainer: NSPersistentContainer = {
        guard let storageName else {
            displayError(.storage)
            return NSPersistentContainer(name: "")
        }
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
    
    public init() {}
    
    public init(storageName: String) { self.storageName = storageName }
    
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
    
    open func create<E>(type _: E.Type) async throws -> E {
        do {
            guard let object = NSEntityDescription.insertNewObject(forEntityName: "\(E.self)", into: context) as? E
            else {
                throw CoreDataError.create
            }
            try context.save()
            return object
        } catch {
            throw CoreDataError.save
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
    
    open func read<E>(
        type _: E.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) async throws -> [E] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(E.self)")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            guard let objects = try context.fetch(fetchRequest) as? [E]
            else {
                throw CoreDataError.fetch
            }
            return objects
        } catch {
            throw CoreDataError.read
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
    
    open func update() async throws {
        do {
            try context.save()
        } catch {
            throw CoreDataError.update
        }
    }

    open func delete(objects: [NSManagedObject], completion: @escaping ((Result<Void, CoreDataError>) -> Void)) {
        do {
            for object in objects {
                guard object.managedObjectContext == context else {
                    completion(.failure(.storage))
                    return
                }
                context.delete(object)
            }
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.delete))
        }
    }
    
    open func delete(objects: [NSManagedObject]) async throws {
        do {
            for object in objects {
                guard object.managedObjectContext == context else {
                    throw CoreDataError.storage
                }
                context.delete(object)
            }
            try context.save()
        } catch {
            throw CoreDataError.delete
        }
    }
    
    private func displayError(_ error: CoreDataError) {
        let alert = UIAlertController(title: "Error", message: error.customMessage, preferredStyle: .alert)
        alert.addAction(.init(title: "Close", style: .cancel))
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(alert, animated: true)
            }
        } else {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        }
    }
}
