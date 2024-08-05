//
//  CTCoreDataManagable.swift
//
//
//  Created by Cem Telliagaoglu on 5.08.2024.
//

import Foundation
import CoreData

protocol CTCoreDataManagable: AnyObject {
    var storageName: String? { get set }
    func create<E: NSManagedObject>(
        type _: E.Type,
        completion: @escaping ((Result<E, CoreDataError>) -> Void)
    )
    func read<E: NSManagedObject>(
        type: E.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        completion: @escaping ((Result<[E], CoreDataError>) -> Void)
    )
    func update(
        completion: @escaping ((Result<Void, CoreDataError>) -> Void)
    )
    func delete(
        objects: [NSManagedObject],
        completion: @escaping ((Result<Void, CoreDataError>) -> Void)
    )
    @available(iOS 13, *) func create<E: NSManagedObject>(
        type _: E.Type
    ) async throws -> E
    @available(iOS 13, *) func read<E: NSManagedObject>(
        type _: E.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) async throws -> [E]
    @available(iOS 13, *) func update() async throws
    @available(iOS 13, *) func delete(
        objects: [NSManagedObject]
    ) async throws
}
