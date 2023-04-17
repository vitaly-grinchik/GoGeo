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
        
    }
        
//        view.addSubview(activityIndicator)
//        layoutIndicator()
        
//        activityIndicator.startAnimating()
//
//        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
//            self.getChunkOfCountries { data in
//                self.allCountries.append(contentsOf: data.data)
//
//                if let nextIndex = data.links.firstIndex(where: { $0.rel == "next" }) {
//                    self.url = List.hostUrl.rawValue + data.links[nextIndex].href
//                } else {
//                    self.activityIndicator.stopAnimating()
//                    timer.invalidate()
//                    print("Downloaded")
//                }
//
//                // Print out data
//                data.data.forEach { print($0.name) }
//                print("Left to download: \(data.metadata.currentOffset)")
//                print("Next batch: \(self.url)")
//
//            }
//        }
//    }
//
//    private func getChunkOfCountries(completion: @escaping (CountriesResponse) -> Void) {
//        NetworkManager.shared.fetch(CountriesResponse.self, from: url) { result in
//            switch result {
//            case .success(let countries):
//                completion(countries)
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
}

//extension StartViewController {
//
//    private func layoutIndicator() {
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
//        )
//    }
//}
