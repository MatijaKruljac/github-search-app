//
//  DetailsScreenViewController.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 26/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class DetailsScreenViewController: BaseViewController {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorValueLabel: UILabel!
    @IBOutlet weak var repositoryValueLabel: UILabel!
    @IBOutlet weak var languageValueLabel: UILabel!
    @IBOutlet weak var createdValueLabel: UILabel!
    @IBOutlet weak var updatedValueLabel: UILabel!
    @IBOutlet weak var watchersValueLabel: UILabel!
    @IBOutlet weak var forksValueLabel: UILabel!
    @IBOutlet weak var issuesValueLabel: UILabel!
    @IBOutlet weak var descriptionValueTextView: UITextView!
    @IBOutlet weak var detailsOnWebButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        setupAuthorAvatarImage()
        setupValuesForLabels()
        setupDetailsOnWebButton()
    }
    
    private func setupAuthorAvatarImage() {
        guard let data = viewControllerDependencies.data else { return }
        if case .element(let resultElement) = data {
            let avatarUrl = URL(string: resultElement.authorThumbnailUrl.stringValue)
            let placeholderAvatar = UIImage(named: "avatar_placeholder.jpg")
            authorImageView.sd_setImage(with: avatarUrl, placeholderImage: placeholderAvatar)
        }
    }
    
    private func setupValuesForLabels() {
        guard let data = viewControllerDependencies.data else { return }
        if case .element(let resultElement) = data {
            authorValueLabel.text = resultElement.authorName.stringValue
            repositoryValueLabel.text = resultElement.repositoryName.stringValue
            languageValueLabel.text = resultElement.language.stringValue
            createdValueLabel.text = resultElement.dateOfCreation.stringValue
            updatedValueLabel.text = resultElement.dateOfUpdate.stringValue
            
            if let numberOfWatchers = resultElement.numberOfWatchers.integerValue {
                watchersValueLabel.text = "\(numberOfWatchers)"
            }
            if let numberOfForks = resultElement.numberOfForks.integerValue {
                forksValueLabel.text = "\(numberOfForks)"
            }
            if let numberOfIssues = resultElement.numberOfIssues.integerValue {
                issuesValueLabel.text = "\(numberOfIssues)"
            }
            
            descriptionValueTextView.text = resultElement.description.stringValue
        }
    }
    
    private func setupDetailsOnWebButton() {
        detailsOnWebButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let data = self?.viewControllerDependencies.data else { return }
                guard let viewModel = self?.viewControllerDependencies.viewModel as? DetailsScreenViewModel else { return }
                if case .element(let resultElement) = data {
                    viewModel.openDetailsInExternBrowser(for: resultElement)
                }
            }).disposed(by: disposeBag)
    }
}
