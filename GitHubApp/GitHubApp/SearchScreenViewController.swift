//
//  SearchScreenViewController.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 25/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchScreenViewController: BaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var starsSwitch: UISwitch!
    @IBOutlet weak var forksSwitch: UISwitch!
    @IBOutlet weak var updatedSwitch: UISwitch!
    @IBOutlet weak var fetchingDataIndicator: UIActivityIndicatorView!

    internal var data = Variable([ResultElement]())
    fileprivate var sort: Sort?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub Search"
        setupData()
        setupSearchBar()
        setupSearchResultTableView()
        setupDataChangeObservation()
        setupStarsSortSwitchObservation()
        setupForksSortSwitchObservation()
        setupUpdateSortSwitchObservation()
        setupFetchingDataIndicator()
    }
    
    private func setupData() {
        guard let data = viewControllerDependencies.data else { return }
        if case .elements(let resultElements) = data {
            self.data.value = resultElements
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self;
    }
    
    private func setupSearchResultTableView() {
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        
        searchResultTableView.register(SearchScreenTableCell.self,
            forCellReuseIdentifier: String(describing: SearchScreenTableCell.self))
        
        searchResultTableView.register(UINib(nibName: String(describing: SearchScreenTableCell.self),
            bundle: nil), forCellReuseIdentifier: String(describing: SearchScreenTableCell.self))
    }
    
    private func setupDataChangeObservation() {
        data.asObservable()
            .subscribe { [weak self] _ in
                self?.searchResultTableView.reloadData()
            }.addDisposableTo(disposeBag)
    }
    
    private func setupStarsSortSwitchObservation() {
        starsSwitch.rx.value.subscribe(onNext: { [weak self] value in
            self?.forksSwitch.setOn(false, animated: true)
            self?.updatedSwitch.setOn(false, animated: true)
            self?.setSortIfSwitchesAreOff()
            if value {
                self?.sort = Sort.stars
                self?.handleSwitchValueChange()
            }
        }).addDisposableTo(disposeBag)
    }
    
    private func setupForksSortSwitchObservation() {
        forksSwitch.rx.value.subscribe(onNext: { [weak self] value in
            self?.starsSwitch.setOn(false, animated: true)
            self?.updatedSwitch.setOn(false, animated: true)
            self?.setSortIfSwitchesAreOff()
            if value {
                self?.sort = Sort.forks
                self?.handleSwitchValueChange()
            }
        }).addDisposableTo(disposeBag)
    }
    
    private func setupUpdateSortSwitchObservation() {
        updatedSwitch.rx.value.subscribe(onNext: { [weak self] value in
            self?.starsSwitch.setOn(false, animated: true)
            self?.forksSwitch.setOn(false, animated: true)
            self?.setSortIfSwitchesAreOff()
            if value {
                self?.sort = Sort.updated
                self?.handleSwitchValueChange()
            }
        }).addDisposableTo(disposeBag)
    }
    
    private func setSortIfSwitchesAreOff() {
        if !starsSwitch.isOn && !forksSwitch.isOn && !updatedSwitch.isOn {
            sort = nil
            refreshDataWhenSwitchesAreOff()
        }
    }
    
    private func refreshDataWhenSwitchesAreOff() {
        if data.value.count > 0 {
            handleSwitchValueChange()
        }
    }
    
    private func handleSwitchValueChange() {
        guard let searchBarText = searchBar.text, searchBarText.isEmptyAfterTrimmingWhitespaces else {
            showAlert()
            return
        }
        sendRequestForData(with: searchBarText)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Warning",
            message: "You did not enter query!",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupFetchingDataIndicator() {
        fetchingDataIndicator.isHidden = true
    }
}

extension SearchScreenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchScreenTableCell.self), for: indexPath) as? SearchScreenTableCell else {
            return UITableViewCell()
        }
        cell.resultElement = data.value[indexPath.row]
        cell.setupLabels()
        
        return cell
    }
}

extension SearchScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultElement = data.value[indexPath.row]
        if case .null( _) = resultElement.errorMessage {
            viewControllerDependencies
                .navigationService
                .pushDetailsScreenViewController(withResultElement: resultElement)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchScreenViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text, searchQuery.isEmptyAfterTrimmingWhitespaces else { return }
        sendRequestForData(with: searchQuery)
    }
    
    fileprivate func sendRequestForData(with searchQuery: String) {
        shouldHideFetchingDataIndicator(false)
        guard let searchScreenViewModel = viewControllerDependencies.viewModel as? SearchScreenViewModel else { return }
        searchScreenViewModel.callFetchRawResultAndParseIt(for: searchQuery, with: sort)
            .asObservable()
            .subscribe(onNext: { [weak self] value in
                self?.data.value = value
                self?.shouldHideFetchingDataIndicator(true)
            }).disposed(by: disposeBag)
        searchBar.endEditing(true)
    }
    
    fileprivate func shouldHideFetchingDataIndicator(_ shouldHide: Bool) {
        if shouldHide {
            fetchingDataIndicator.stopAnimating()
        } else {
            fetchingDataIndicator.startAnimating()
        }
        fetchingDataIndicator.isHidden = shouldHide
    }
}

extension String {
    
    var isEmptyAfterTrimmingWhitespaces: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespaces) != ""
    }
}
