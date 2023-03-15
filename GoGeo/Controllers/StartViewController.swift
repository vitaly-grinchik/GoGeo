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
        
        NetworkManager.shared.fetchCities()
    }
}

