//
//  HomeInteractor.swift
//  SampleProjectAsyncAwait
//
//  Created by Cem Telliagaoglu on 12.05.2024.
//

import Foundation

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
        Task {
            do {
                let contacts = try await coreDataManager.fetchContacts(by: searchText, isAscending: isAscending)
                self.presenter?.fetchedContacts(contacts)
            } catch {
                presenter?.presentError(error.localizedDescription)
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
