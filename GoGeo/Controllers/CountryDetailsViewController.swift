//
//  CountryDetailsViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 18.04.23.
//

import UIKit

final class CountryDetailsViewController: UIViewController {

    @IBOutlet var countryNameLabel: UILabel!
    
    var country: Country?
    
    var countryName = "No data"
    
    var countryId = "No data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryNameLabel.text = countryName
        getCountryId { print($0)}
    }

    private func showCountryDetails() {
        
    }
    
    private func getCountryId(completion: @escaping (String) -> Void) {
        
        let countryNamePrefix = countryName.split(separator: " ").first
        let url = "\(Url.countrySearchUrl.rawValue)\(countryNamePrefix ?? "")"
        
        NetworkManager.shared.fetch(CountryResponse.self, from: url) { [weak self] result in
            switch result {
            case .success(let country): self?.countryId = country.data.first?.wikiDataId ?? ""
                completion(self?.countryId ?? "No data")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCountryDetails() -> CountryDetails? {
        return nil
    }
    
}
