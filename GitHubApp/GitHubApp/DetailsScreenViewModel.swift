//
//  DetailsScreenViewModel.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 26/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import RxSwift

class DetailsScreenViewModel: BaseViewModel {
    
    func openDetailsInExternBrowser(for resultElement: ResultElement) {
        guard let url = URL(string: "\(GitHubUrls.base)/\(resultElement.authorName.stringValue)/\(resultElement.repositoryName.stringValue)")
            else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
