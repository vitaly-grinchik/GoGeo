//
//  CountryDetailsViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 18.04.23.
//

import UIKit

final class CountryDetailsViewController: UIViewController {

    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var wikiIDLabel: UILabel!
    
    @IBOutlet var flagImageView: UIImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var countryName = ""
    var countryInfo: CountryInfo?
    var flagImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryNameLabel.text = countryName
        wikiIDLabel.text = ""
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        // Chain of requests:
        //  First request: get country ID for selected country
        //      Delay for 1.3 sec to keep on API free use terms
        //  Second request: get detailed info on country using its ID
        //  Third request: get country flag image data
        getIdForCountry(countryName) { [weak self] id in
            Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false) { _ in
                self?.getInfoOnCountryWithId(id) { countryInfo in
                    self?.countryInfo = countryInfo
                    
                    self?.getFlagImg { data in
                        self?.flagImage = UIImage(data: data)
//                        self?.updateUI()
                    }
                }
            }
        }
        
    }
    
    private func getFlagImg(completion: @escaping (Data) -> Void) {
        let flagImgageUrl = countryInfo?.data.flagImageUri
        NetworkManager.shared.fetchImage(from: flagImgageUrl) { result in
            switch result {
            case .success(let flagImageData):
                completion(flagImageData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getIdForCountry(_ country: String, completion: @escaping (String) -> Void) {
        
        let countryNamePrefix = country.split(separator: " ").first
        let url = "\(Url.countrySearchUrl.rawValue)\(countryNamePrefix ?? "")"
        
        NetworkManager.shared.fetch(CountryResponse.self, from: url) { result in
            switch result {
            case .success(let country):
                let id = country.data.first?.wikiDataId ?? ""
                completion(id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getInfoOnCountryWithId(_ countryId: String, completion: @escaping (CountryInfo) -> Void) {
        
        let url = "\(Url.countryDetailsSearchUrl.rawValue)\(countryId)"
        
        NetworkManager.shared.fetch(CountryInfo.self, from: url) { result in
            switch result {
            case .success(let countryInfo):
                completion(countryInfo)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
