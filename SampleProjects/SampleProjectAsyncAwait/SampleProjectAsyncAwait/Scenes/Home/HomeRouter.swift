//
//  HomeRouter.swift
//  SampleProjectAsyncAwait
//
//  Created by Cem Telliagaoglu on 12.05.2024.
//

import UIKit

protocol HomePresenterToRouter: AnyObject {
    var view: HomeViewController? { get set }
    func routeToDetails(for contact: Person)
    func routeToNewContact()
}

final class HomeRouter: HomePresenterToRouter {
    //MARK: - Properties
    
    weak var view: HomeViewController?
    
    //MARK: - Methods
    
    func routeToNewContact() {
        let viewController = DetailsRouter.createModule()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func routeToDetails(for contact: Person) {
        let viewController = DetailsRouter.createModule()
        viewController.configure(with: contact)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    static func createModule() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return HomeViewController() }
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = viewController
        return viewController
    }
}
