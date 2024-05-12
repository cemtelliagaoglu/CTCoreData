//
//  HomeInteractor.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 18.04.2024.
//

import Foundation
import CTCoreData

protocol HomePresenterToInteractor: AnyObject {
    var presenter: HomeInteractorToPresenter? { get set}
    func fetchContacts(by searchText: String?)
    func updateSorting(for contacts: [Person])
}

final class HomeInteractor: HomePresenterToInteractor {
    //MARK: - Properties
    
    weak var presenter: HomeInteractorToPresenter?
    
    private let coreDataManager = CoreDataManager.shared
    private var isAscending: Bool = true
    
    
    //MARK: - Lifecycle
    
    init() {
        isAscending = UserDefaults.standard.object(forKey: "isAscending") as? Bool ?? true
    }
    
    //MARK: - Methods
    
    func fetchContacts(by searchText: String?) {
        coreDataManager.fetchContacts(by: searchText, isAscending: isAscending) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(contacts):
                self.presenter?.fetchedContacts(contacts)
            case let .failure(error):
                self.presenter?.presentError(error.customMessage)
            }
        }
    }
    
    func updateSorting(for contacts: [Person]) {
        let newValue = !isAscending
        UserDefaults.standard.setValue(newValue, forKey: "isAscending")
        isAscending = newValue
        var tempContacts = [Person]()
        if isAscending {
            tempContacts = contacts.sorted(by: { $0.name ?? "" < $1.name ?? "" })
        } else {
            tempContacts = contacts.sorted(by: { $0.name ?? "" > $1.name ?? "" })
        }
        presenter?.fetchedContacts(tempContacts)
    }
}
