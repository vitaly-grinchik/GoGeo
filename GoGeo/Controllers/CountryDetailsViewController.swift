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
    
    private let apiManager = RapidManager.shared
    
    var country: String!
    var countryBrief: CountryBrief?
    var countryDetails: CountryDetails?
    var flagImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryNameLabel.text = country
        
        flagImageView.alpha = 0
        infoStackView.alpha = 0
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        getInfoOnCountry()
    }
    
    override func viewWillLayoutSubviews() {
        activityIndicator.style = .large
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: - Fetch data
        
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
    
    private func getInfoOnCountry() {
        Task {
            do {
                countryBrief = try await apiManager.fetchBriefInfoOnCountry(country)
                print(countryBrief?.name ?? "no name")
                print(countryBrief?.code ?? "no code")
                print(countryBrief?.wikiDataId ?? "no ID")
                updateUI()
            } catch APIError.jsonIncompleteData {
                print(APIError.jsonIncompleteData.rawValue)

            } catch APIError.invalidAPIUrl {
                print(APIError.invalidAPIUrl.rawValue)

            } catch NetworkError.invalidUrl {
                print(NetworkError.invalidUrl.rawValue)
            }
        }
    }
    
}
