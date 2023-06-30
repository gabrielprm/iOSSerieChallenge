//
//  MovieListPresenter.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import Foundation
import UIKit

protocol SeriesListPresenterProtocol {
    func fetchSeries()
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void)
}

class SeriesListPresenter: SeriesListPresenterProtocol {
    let service: SeriesListServiceProtocol
    
//    let imageCache = [NSCache<NSString, UIImage>]()
    
    weak var viewController: SeriesListPresenterView?
    
    init(service: SeriesListServiceProtocol) {
        self.service = service
    }
    
    func fetchSeries() {
        service.fetchAllSeries { result in
            switch result {
            case .success(let model):
                model.forEach { [weak self] serie in
                    self?.downloadImage(url:  serie.show.image.imageUrl, completion: { image in
                        if let image = image {
                            self?.viewController?.displaySeries(name: serie.show.name, image: image)
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
    
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void){
        guard let imageURL = URL(string: url) else {
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
}
