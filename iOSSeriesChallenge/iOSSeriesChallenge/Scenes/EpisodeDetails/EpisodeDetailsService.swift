//
//  EpisodeDetailsService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import Foundation

protocol EpisodeDetailsServicing {
    typealias DownloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    
    func downloadImage(from url: URL, completion: @escaping DownloadImageCompletionHandler)
}

final class EpisodeDetailsService: EpisodeDetailsServicing {
    private let session: SessionRequest
    
    init(session: SessionRequest = URLSession.shared) {
        self.session = session
    }
    
    func downloadImage(from url: URL, completion: @escaping DownloadImageCompletionHandler) {
        session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.imageDownload))
                return
            }
            
            guard let data = data else {
                completion(.failure(.imageDownload))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
