//
//  MovieListService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import Foundation

protocol SeriesListServicing {
    typealias fetchSeriesCompletionHandler = (Result<[HomeSeriesListModel], ServiceSeriesListErrors>) -> Void
    typealias searchSeriesCompletionHandler = (Result<[EmbeddedShow], ServiceSeriesListErrors>) -> Void
    typealias downloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    
    func fetchAllSeries(completion: @escaping fetchSeriesCompletionHandler)
    func searchSeries(query: String, completion: @escaping searchSeriesCompletionHandler)
    func downloadImage(from url: URL, completion: @escaping downloadImageCompletionHandler)
}

class SeriesListService: SeriesListServicing {
    private let session: SessionRequest
    private var dataTask: URLSessionDataTaskProtocol?
    
    init(session: SessionRequest = URLSession.shared) {
        self.session = session
    }
    
    func fetchAllSeries(completion: @escaping fetchSeriesCompletionHandler) {
        let tvMazeUrl = "https://api.tvmaze.com/schedule/full"
        
        guard let url = URL(string: tvMazeUrl) else {
            completion(.failure(ServiceSeriesListErrors.urlNil))
            return
        }
        
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url) { data, response, error in
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
        }
        
        dataTask?.resume()
    }
    
    func searchSeries(query: String, completion: @escaping searchSeriesCompletionHandler) {
        let serviceURL = "https://api.tvmaze.com/search/shows?q=\(query)"
        
        guard let url = URL(string: serviceURL) else {
            completion(.failure(ServiceSeriesListErrors.urlNil))
            return
        }
        
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(ServiceSeriesListErrors.dataNil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([EmbeddedShow].self, from: data)
                completion(.success(decodedData))
            } catch _ {
                completion(.failure(ServiceSeriesListErrors.parseFailure))
            }
        }
        dataTask?.resume()
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
