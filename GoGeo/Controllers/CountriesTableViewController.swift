//
//  CountriesTableViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 30.03.23.
//

import UIKit

final class CountriesTableViewController: UITableViewController {
    
    private let countries = DataStore.shared.countries
    
    private var filteredCountries = [String]()
    
    private let titles = DataStore.shared.getTitlesForGroups()
    
    private let groupsOfCountries = DataStore.shared.getGroups()
    
    private var isFiltering: Bool {
        searchController.searchBar.text != nil && searchController.searchBar.text != ""
    }
    
    // nil cause this VC is being used for results presentation
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTableView()
        setupNaviBar()
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupNaviBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Countries"
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        // Make search results interactible
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a country"
        // Add seacrh bar onto navigation bar
        navigationItem.searchController = searchController
    }

}

// MARK: - Navigation
extension CountriesTableViewController {
    
    private func showInfoOn(_ country: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsViewController else { return }
        detailsVC.countryName = country
        present(detailsVC, animated: true)
    }
    
    
    
}

// MARK: - UITableViewDataSource
extension CountriesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        isFiltering ? 1 : titles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        isFiltering ? "Found: \(filteredCountries.count)" : titles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredCountries.count : groupsOfCountries[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = isFiltering ? filteredCountries[indexPath.row] : groupsOfCountries[indexPath.section][indexPath.row]
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = country
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension CountriesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = isFiltering ? filteredCountries[indexPath.row] : groupsOfCountries[indexPath.section][indexPath.row]
        showInfoOn(country)
    }
}

// MARK: - Search results updating
extension CountriesTableViewController: UISearchResultsUpdating {
    
    // Update filter on text change in search bar
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        filteredCountries = countries.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
    
}
