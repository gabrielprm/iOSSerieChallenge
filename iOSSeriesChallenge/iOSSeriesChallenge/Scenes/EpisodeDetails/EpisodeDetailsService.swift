//
//  EpisodeDetailsService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import Foundation

protocol EpisodeDetailsServicing {
    typealias downloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    
    func downloadImage(from url: URL, completion: @escaping downloadImageCompletionHandler)
}

class EpisodeDetailsService: EpisodeDetailsServicing {
    private let session: SessionRequest
    
    init(session: SessionRequest = URLSession.shared) {
        self.session = session
    }
    
    func downloadImage(from url: URL, completion: @escaping downloadImageCompletionHandler) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(ServiceSeriesListErrors.imageDownload))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(ServiceSeriesListErrors.imageDownload))
            }
        }.resume()
    }
}
