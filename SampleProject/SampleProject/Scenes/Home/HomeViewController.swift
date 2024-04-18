//
//  HomeViewController.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 18.04.2024.
//

import UIKit

protocol HomePresenterToView: AnyObject {
    func reloadData()
    func displayError(_ message: String)
}

final class HomeViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonPressed))
        return button
    }()
    
    var presenter: HomePresenter?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    //MARK: - Methods
    
    private func setupView() {
        tableView.register(
            UINib(nibName: "ContactCell", bundle: nil),
            forCellReuseIdentifier: ContactCell.reuseIdentifier
        )
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItem = sortButton
        
    }
    
    @objc private func addButtonPressed() {
        presenter?.addButtonPressed()
    }
    
    @objc private func sortButtonPressed() {
        presenter?.sortButtonPressed()
    }
}

    //MARK: - UISearchTextFieldDelegate

extension HomeViewController: UISearchTextFieldDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTextDidChange(searchText)
    }
}

    //MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfCells() ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseIdentifier) as? ContactCell else { return UITableViewCell() }
        let model = presenter?.modelForCell(at: indexPath.row)
        cell.configure(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter?.didSelectItem(at: indexPath.row)
    }
}

//MARK: - PresenterToView

extension HomeViewController: HomePresenterToView {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
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
