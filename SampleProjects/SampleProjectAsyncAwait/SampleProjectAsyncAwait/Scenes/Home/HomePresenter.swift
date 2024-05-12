//
//  HomePresenter.swift
//  SampleProjectAsyncAwait
//
//  Created by Cem Telliagaoglu on 12.05.2024.
//

import Foundation

protocol HomeViewToPresenter: AnyObject {
    var view: HomePresenterToView? { get set }
    func viewWillAppear()
    func numberOfCells() -> Int
    func modelForCell(at index: Int) -> PersonViewModel?
    func addButtonPressed()
    func didSelectItem(at index: Int)
    func searchTextDidChange(_ text: String)
    func sortButtonPressed()
}

protocol HomeInteractorToPresenter: AnyObject {
    var interactor: HomePresenterToInteractor? { get set }
    func fetchedContacts(_ contacts: [Person])
    func presentError(_ message: String)
    func searchTextDidChange(_ text: String)
}

final class HomePresenter: HomeViewToPresenter {
    //MARK: - Properties
    
    weak var view: HomePresenterToView?
    var interactor: HomePresenterToInteractor?
    var router: HomeRouter?
    
    private var contacts: [Person]?
    private var viewModels: [PersonViewModel]?
    
    //MARK: - Methods
    
    func viewWillAppear() {
        interactor?.fetchContacts(by: nil)
    }
    
    func numberOfCells() -> Int {
        guard viewModels?.count != 0 else {
            return 1
        }
        return viewModels?.count ?? 1
    }
    
    func modelForCell(at index: Int) -> PersonViewModel? {
        guard let viewModels,
              index < viewModels.count else { return nil }
        return viewModels[index]
    }
    
    func searchTextDidChange(_ text: String) {
        interactor?.fetchContacts(by: text)
    }
    
    func addButtonPressed() {
        router?.routeToNewContact()
    }
    
    func didSelectItem(at index: Int) {
        guard let contacts,
              index < contacts.count else { return }
        router?.routeToDetails(for: contacts[index])
    }
    
    func sortButtonPressed() {
        guard let contacts else { return }
        interactor?.updateSorting(for: contacts)
    }
}

    //MARK: - InteractorToPresenter

extension HomePresenter: HomeInteractorToPresenter {
    func fetchedContacts(_ contacts: [Person]) {
        self.contacts = contacts
        var tempViewModels = [PersonViewModel]()
        for contact in contacts {
            tempViewModels.append(
                .init(
                    name: contact.name,
                    number: contact.number
                )
            )
        }
        self.viewModels = tempViewModels
        view?.reloadData()
    }
    
    func presentError(_ message: String) {
        view?.displayError(message)
    }
}
