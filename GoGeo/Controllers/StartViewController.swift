//
//  StartViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 13.03.23.
//

import UIKit

class StartViewController: UIViewController {

    private var allCountries = [Country]()
    
    private var printListCount: ([Country]) -> Void = { print($0.count) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCountriesList(completion: printListCount)
    }
    
    private func getCountriesList(completion: @escaping ([Country]) -> Void) {
        
        var currentOffset = 0
        var totalCount = 0
        var url = List.hostUrl.rawValue + List.countriesUrl.rawValue
        
        repeat {
            NetworkManager.shared.fetch(CountriesResponse.self, from: url)
            { [weak self] result in
                switch result {
                case .success(let countries):
                    self?.allCountries.append(contentsOf: countries.data)
                    
                    currentOffset = countries.metadata.currentOffset
                    totalCount = countries.metadata.totalCount
                    // Get link for next 5 records
                    if let nextIndex = countries.links.firstIndex(where: { $0.rel == "next" }) {
                        url = List.hostUrl.rawValue + countries.links[nextIndex].href
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } while (totalCount - currentOffset) > 5
        
        completion(allCountries)
    }
}

