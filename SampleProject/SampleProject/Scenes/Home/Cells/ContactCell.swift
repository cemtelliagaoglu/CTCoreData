//
//  ContactCell.swift
//  SampleProject
//
//  Created by Cem Telliagaoglu on 18.04.2024.
//

import UIKit

class ContactCell: UITableViewCell {
    //MARK: - Properties
    
    static let reuseIdentifier = "contactCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emptyContainerView: UIView!
    
    private var viewModel: PersonViewModel?
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    //MARK: - Methods
    
    private func setupView() {
        guard let viewModel else {
            emptyContainerView.isHidden = false
            return
        }
        nameLabel.text = viewModel.name
        numberLabel.text = viewModel.number
        emptyContainerView.isHidden = true
    }
    
    func configure(_ model: PersonViewModel?) {
        viewModel = model
    }
}
