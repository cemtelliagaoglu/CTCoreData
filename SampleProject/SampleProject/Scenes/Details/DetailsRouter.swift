//
//  DetailsRouter.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 18.04.2024.
//

import UIKit

protocol DetailsPresenterToRouter: AnyObject {
    var view: DetailsViewController? { get set }
    func popVC()
}

final class DetailsRouter: DetailsPresenterToRouter {
    weak var view: DetailsViewController?
    
    func popVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view?.navigationController?.popViewController(animated: true)
        }
    }
    
    static func createModule() -> DetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return DetailsViewController() }
        let presenter = DetailsPresenter()
        let interactor = DetailsInteractor()
        let router = DetailsRouter()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = viewController
        return viewController
    }
    
}
