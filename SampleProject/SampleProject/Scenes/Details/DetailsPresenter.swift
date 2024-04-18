//
//  DetailsPresenter.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 18.04.2024.
//

import Foundation

protocol DetailsViewToPresenter: AnyObject {
    var view: DetailsPresenterToView? { get set }
    func configured(with model: Person)
    func viewDidLoad()
    func saveButtonTapped(name: String, number: String)
    func deleteButtonTapped()
}

protocol DetailsInteractorToPresenter: AnyObject {
    var interactor: DetailsPresenterToInteractor? { get set }
    func savedContactSuccessfully()
    func presentError(_ message: String)
}

final class DetailsPresenter: DetailsViewToPresenter {
    //MARK: - Properties
    
    weak var view: DetailsPresenterToView?
    var interactor: DetailsPresenterToInteractor?
    var router: DetailsPresenterToRouter?
    
    private var contact: Person?
    
    func configured(with model: Person) {
        contact = model
    }
    
    func viewDidLoad() {
        guard let contact else { return }
        view?.displayModel(
            .init(
                name: contact.name,
                number: contact.number
             )
        )
    }
    
    func saveButtonTapped(name: String, number: String) {
        if let contact {
            interactor?.saveContact(contact, name: name, number: number)
        } else {
            interactor?.createNewContact(name: name, number: number)
        }
    }
    
    func deleteButtonTapped() {
        guard let contact else { return }
        interactor?.deleteContact(contact)
    }
    
}

//MARK: - InteractorToPresenter

extension DetailsPresenter: DetailsInteractorToPresenter {
    func savedContactSuccessfully() {
        router?.popVC()
    }
    
    func presentError(_ message: String) {
        view?.displayError(message)
    }
}
