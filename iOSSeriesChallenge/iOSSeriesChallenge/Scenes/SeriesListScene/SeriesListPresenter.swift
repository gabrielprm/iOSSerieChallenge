//
//  MovieListPresenter.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import Foundation
import UIKit

protocol SeriesListPresenting {
    func fetchSeries()
    func downloadImage(url: String?, completion: @escaping (UIImage?) -> Void)
    func navigateToDetailsPage(id: Int)
}

class SeriesListPresenter: SeriesListPresenting {
    let service: SeriesListServicing
    let coordinator: SeriesListCoordinating
    weak var viewController: SeriesListDisplaying?
    
    init(service: SeriesListServicing, coordinator: SeriesListCoordinating) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func fetchSeries() {
        service.fetchAllSeries { result in
            switch result {
            case .success(let model):
                model.forEach { [weak self] serie in
                    self?.downloadImage(url:  serie._embedded.show.image?
                        .imageUrl, completion: { image in
                        if let image = image {
                            self?.viewController?.displaySeries(id: serie._embedded.show.id,name: serie._embedded.show.name, image: image)
                        } else {
                            return
                        }
                    })
                }
            case .failure(_):
                break
            }
        }
    }
    
    func downloadImage(url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url ?? "") else {
            completion(nil)
            return
        }
        
        service.downloadImage(from: imageURL) { result in
            switch result {
            case .success(let imageData):
                let image = UIImage(data: imageData)
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func navigateToDetailsPage(id: Int) {
        coordinator.openDetailsPage(id: id)
    }
}
