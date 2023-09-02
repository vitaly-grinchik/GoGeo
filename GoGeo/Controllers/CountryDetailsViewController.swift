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
    var countryBrief: CountryBrief?
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
    
}
