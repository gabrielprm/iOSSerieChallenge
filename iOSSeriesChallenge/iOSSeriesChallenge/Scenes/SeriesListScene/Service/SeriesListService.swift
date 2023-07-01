//
//  MovieListService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import Foundation

protocol SeriesListServicing {
    typealias fetchSeriesCompletionHandler = (Result<[HomeSeriesListModel], ServiceSeriesListErrors>) -> Void
    typealias downloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    
    func fetchAllSeries(completion: @escaping fetchSeriesCompletionHandler)
    func downloadImage(from url: URL, completion: @escaping downloadImageCompletionHandler)
}

class SeriesListService: SeriesListServicing {
    private let session: SessionRequest
    
    init(session: SessionRequest = URLSession.shared) {
        self.session = session
    }
    
    func fetchAllSeries(completion: @escaping fetchSeriesCompletionHandler) {
        
        let tvMazeUrl = "https://api.tvmaze.com/schedule"
        
        guard let url = URL(string: tvMazeUrl) else {
            completion(.failure(ServiceSeriesListErrors.urlNil))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(ServiceSeriesListErrors.dataNil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([HomeSeriesListModel].self, from: data)
                completion(.success(decodedData))
            } catch _ {
                completion(.failure(ServiceSeriesListErrors.parseFailure))
            }
        }.resume()
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
