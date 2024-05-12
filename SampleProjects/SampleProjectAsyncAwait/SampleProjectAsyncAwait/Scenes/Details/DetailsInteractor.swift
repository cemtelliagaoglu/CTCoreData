//
//  DetailsInteractor.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 18.04.2024.
//

import Foundation
import CTCoreData

protocol DetailsPresenterToInteractor: AnyObject {
    var presenter: DetailsInteractorToPresenter? { get set }
    func createNewContact(name: String, number: String)
    func saveContact(_ contact: Person, name: String, number: String)
    func deleteContact(_ contact: Person)
}

final class DetailsInteractor: DetailsPresenterToInteractor {
    //MARK: - Properties
    
    weak var presenter: DetailsInteractorToPresenter?
    
    private let coreDataManager = CoreDataManager.shared
    
    //MARK: - Methods
    
    func createNewContact(name: String, number: String) {
        Task {
            do {
                try await coreDataManager.createNewContact(name: name, number: number)
                presenter?.savedContactSuccessfully()
            } catch {
                presenter?.presentError(error.localizedDescription)
            }
        }
    }
    
    func saveContact(_ contact: Person, name: String, number: String) {
        Task {
            do {
                contact.name = name
                contact.number = number
                try await coreDataManager.update()
                presenter?.savedContactSuccessfully()
            } catch {
                presenter?.presentError(error.localizedDescription)
            }
        }
    }
    
    func deleteContact(_ contact: Person) {
        Task {
            do {
                try await coreDataManager.delete(objects: [contact])
                presenter?.savedContactSuccessfully()
            } catch {
                presenter?.presentError(error.localizedDescription)
            }
        }
    }
}
