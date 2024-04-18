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
    
    //MARK: - Lifecycle
    
    init() {
        coreDataManager.configureDataModel(storageName: "DataModel")
    }
    
    //MARK: - Methods
    
    func createNewContact(name: String, number: String) {
        coreDataManager.create(type: Person.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(person):
                person.name = name
                person.number = number
                self.coreDataManager.update { updateResult in
                    switch updateResult {
                    case .success:
                        self.presenter?.savedContactSuccessfully()
                    case let .failure(error):
                        self.presenter?.presentError(error.customMessage)
                    }
                }
            case let .failure(error):
                self.presenter?.presentError(error.customMessage)
            }
        }
    }
    
    func saveContact(_ contact: Person, name: String, number: String) {
        contact.name = name
        contact.number = number
        coreDataManager.update { [weak self] updateResult in
            guard let self else { return }
            switch updateResult {
            case .success:
                self.presenter?.savedContactSuccessfully()
            case let .failure(error):
                self.presenter?.presentError(error.customMessage)
            }
        }
    }
    
    func deleteContact(_ contact: Person) {
        DispatchQueue.global().async {
            self.coreDataManager.delete(objects: [contact]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    self.presenter?.savedContactSuccessfully()
                case let .failure(error):
                    self.presenter?.presentError(error.customMessage)
                }
            }
        }
    }
}
