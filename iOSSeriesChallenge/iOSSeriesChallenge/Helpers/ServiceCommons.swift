//
//  ServiceCommons.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import Foundation

/// Common service protocol providing shared functionality for all services
protocol CommonServiceProtocol {
    typealias DownloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    func downloadImage(from url: URL, completion: @escaping DownloadImageCompletionHandler)
}

extension CommonServiceProtocol {
    func downloadImage(from url: URL, completion: @escaping DownloadImageCompletionHandler) {
        URLSession.shared.dataTask(with: url) { data, _, error in
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
