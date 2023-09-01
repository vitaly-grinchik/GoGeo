//
//  CountryDetailsViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 18.04.23.
//

import UIKit
import SwiftDraw // for SVG image files

final class CountryDetailsViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var infoStackView: UIStackView!
    
    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var numberOfRegionsLabel: UILabel!
    @IBOutlet var phoneCode: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet var flagImageView: UIImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var countryName: String!
    var countryDetails: CountryDetails?
    var flagImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryNameLabel.text = countryName
        
        flagImageView.alpha = 0
        infoStackView.alpha = 0
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    override func viewWillLayoutSubviews() {
        activityIndicator.style = .large
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Chain of requests:
        //  First request: get country ID for selected country
        //  Delay for 1.3 sec to observe API free use terms (request per second or rarely)
        //  Second request: get detailed info on country using its ID
        //  Third request: get country flag image data
        
        
        getIdForCountry(countryName) { [weak self] id in
            Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false) { _ in
                self?.getInfoOnCountryWithId(id) { country in
                    self?.countryDetails = country
                    
                    self?.downloadFlagImage() { result in
                        switch result {
                        case .success(let image): self?.flagImage = image
                        case .failure(let error): print(error.rawValue)
                        }
                        self?.updateUI()
                    }
                }
            }
        }
    }
    
    private func updateUI() {
        updateLabels()
        
        flagImageView.image = flagImage
        activityIndicator.stopAnimating()
        
        // Info appearance animation
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.flagImageView.alpha = 1
            self?.infoStackView.alpha = 1
        }
    }
    
    private func updateLabels() {
        codeLabel.text = countryDetails?.code ?? ""
        capitalLabel.text = countryDetails?.capital ?? ""
        phoneCode.text = countryDetails?.callingCode ?? ""
        
        if let numberOfRegions = countryDetails?.numRegions {
            numberOfRegionsLabel.text = "\(numberOfRegions)"
        }
        
        currencyLabel.text = countryDetails?.currencyCodes.joined(separator: ", ")
    }
    
    private func downloadFlagImage(completion: @escaping (Result<UIImage, NetError>) -> Void) {
        guard let flagImageUrl = countryDetails?.flagImageUri else { return }
        
        NetworkManager.shared.fetchAFData(using: flagImageUrl) { data in
            switch data {
            case .success(let imageData):
                // Check if image is .svg
                if let flagImage = UIImage(svgData: imageData) {
                    completion(.success(flagImage))
                // Check if other image format
                } else if let flagImage = UIImage(data: imageData) {
                    completion(.success(flagImage))
                } else {
                    // .. or placeholder system image
                    if let flagImage = UIImage(systemName: "image") {
                        completion(.success(flagImage))
                    }
                }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    private func fetchIdForCountry(_ name: String) async throws -> String {
        
        let query = [URLQueryItem(name: "namePrefix", value: name)]
        
        guard let url = Resource(
            host: RapidApi.host.rawValue,
            endpoint: RapidApi.country.rawValue,
            query: query
        ).url else {
            print("Wrong URL")
            throw NetError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = NetworkManager.shared.rapidHeaders
        
        do {
            let country = try await NetworkManager.shared.fetchData(
                CountryBrief.self,
                using: request
            )
            return country.wikiDataId
        } catch {
            throw NetError.requestFailed
        }
    }
    
    private func getInfoOnCountryWithId(_ countryId: String) async throws -> CountryDetails {
        
        guard let url = Resource(
            host: RapidApi.host.rawValue,
            endpoint: RapidApi.country.rawValue,
            query: nil
        ).url?.appending(component: countryId)
        
        else {
            print(NetError.invalidUrl.rawValue)
            throw NetError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = NetworkManager.shared.rapidHeaders
        
        do {
            let countryDetails = try await NetworkManager.shared.fetchData(
                CountryDetails.self,
                using: request
            )
            return countryDetails
        } catch {
            throw NetError.requestFailed
        }
    }
    
}
