//
//  ServiceCommons.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import Foundation

protocol CommomServiceProtocol {
    typealias downloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    func downloadImage(from url: URL, completion: @escaping downloadImageCompletionHandler)
}

extension CommomServiceProtocol {
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
