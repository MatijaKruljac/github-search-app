//
//  SearchScreenTableCell.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 26/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import UIKit

class SearchScreenTableCell: UITableViewCell {
    
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var repositoryValueLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorValueLabel: UILabel!
    
    var resultElement: ResultElement!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabels() {
        if case .string( _) = resultElement.errorMessage {
            repositoryLabel.text = "Error: "
            repositoryValueLabel.text = resultElement.errorMessage.stringValue
            authorLabel.isHidden = true
            authorValueLabel.isHidden = true
        } else {
            repositoryLabel.text = "Repository: "
            repositoryValueLabel.text = resultElement.repositoryName.stringValue
            authorValueLabel.text = resultElement.authorName.stringValue
            authorLabel.isHidden = false
            authorValueLabel.isHidden = false
        }
    }
}
