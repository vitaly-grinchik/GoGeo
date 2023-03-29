//
//  StartViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 13.03.23.
//

import UIKit

class StartViewController: UIViewController {

    private var allCountries = [Country]()
    
    private var url = List.hostUrl.rawValue + List.countriesUrl.rawValue
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
//    private var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        layoutIndicator()
        
        activityIndicator.startAnimating()
        
        getChunkOfCountries { countries, totalCount, offset, url in
            self.allCountries.append(contentsOf: countries)
            self.allCountries.forEach { print($0.name) }
            print("Left to download: \(totalCount - offset)")
            print("Next batch: \(url)")
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func getChunkOfCountries(completion: @escaping ([Country], Int, Int, String) -> Void) {
        
        NetworkManager.shared.fetch(CountriesResponse.self, from: url) { [self] result in
            
            switch result {
            case .success(let countries):
                
                if let nextIndex = countries.links.firstIndex(where: { $0.rel == "next" }) {
                    self.url = List.hostUrl.rawValue + countries.links[nextIndex].href
                }
                
                completion(countries.data,
                           countries.metadata.totalCount,
                           countries.metadata.currentOffset,
                           url
                )
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
                
    }
    
    private func layoutIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )
    }
}

