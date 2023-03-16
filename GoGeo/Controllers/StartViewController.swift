//
//  StartViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 13.03.23.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCities()
    }
    
    private func fetchCities() {
        NetworkManager.shared.fetch(City.self, from: List.citiesUrl.rawValue)
        { [weak self] result in
            switch result {
            case .success(let ciites):
                self?.printInfoOnCities(ciites.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func printInfoOnCities(_ cities: [CityDetails]) {
        cities.forEach { city in
            
            let description = """
                Country:    \(city.country) (code: \(city.countryCode))
                City:       \(city.name)
                GPS:        \(city.latitude):\(city.latitude)
                ---------------------------------------------------------
                
                """
            print(description)
        }
    }
}

