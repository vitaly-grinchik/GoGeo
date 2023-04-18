//
//  DetailsViewController.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 18.04.23.
//

import UIKit

final class DetailsViewController: UIViewController {

    @IBOutlet var countryNameLabel: UILabel!
    
    var countryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countryNameLabel.text = countryName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
