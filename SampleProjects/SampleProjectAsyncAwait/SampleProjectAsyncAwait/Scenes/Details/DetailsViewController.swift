//
//  DetailsViewController.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 18.04.2024.
//

import UIKit

protocol DetailsPresenterToView: AnyObject {
    func displayModel(_ viewModel: PersonViewModel)
    func displayError(_ message: String)
}

final class DetailsViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonTapped))
        button.isHidden = true
        return button
    }()
    
    private var viewModel: PersonViewModel?
    
    var presenter: DetailsPresenter?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    //MARK: - Methods
    
    func configure(with contact: Person) {
        presenter?.configured(with: contact)
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: "Are you sure?", message: "You cannot undo this operation", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            guard let self else { return }
            self.presenter?.deleteButtonTapped()
        }
        alert.addAction(yesAction)
        alert.addAction(.init(title: "No", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              !name.isEmpty,
              let number = numberTextField.text,
              !number.isEmpty else { return }
        presenter?.saveButtonTapped(name: name, number: number)
    }
}

//MARK: - PresenterToView

extension DetailsViewController: DetailsPresenterToView {
    func displayModel(_ viewModel: PersonViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.saveButton.setTitle("Save", for: .normal)
            self.deleteButton.isHidden = false
            self.nameTextField.text = viewModel.name
            self.numberTextField.text = viewModel.number
        }
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Close", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.present(alert, animated: true)
        }
    }
}
