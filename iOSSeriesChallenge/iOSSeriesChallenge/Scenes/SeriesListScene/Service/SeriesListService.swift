//
//  SeriesListService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import Foundation

protocol SeriesListServicing {
    typealias FetchSeriesCompletionHandler = (Result<[HomeSeriesListModel], ServiceSeriesListErrors>) -> Void
    typealias SearchSeriesCompletionHandler = (Result<[EmbeddedShow], ServiceSeriesListErrors>) -> Void
    typealias DownloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    
    func fetchAllSeries(completion: @escaping FetchSeriesCompletionHandler)
    func searchSeries(query: String, completion: @escaping SearchSeriesCompletionHandler)
    func downloadImage(from url: URL, completion: @escaping DownloadImageCompletionHandler)
}

final class SeriesListService: SeriesListServicing {
    private let session: SessionRequest
    private var dataTask: URLSessionDataTaskProtocol?
    
    init(session: SessionRequest = URLSession.shared) {
        self.session = session
    }
    
    func fetchAllSeries(completion: @escaping FetchSeriesCompletionHandler) {
        let urlString = "https://api.tvmaze.com/schedule/full"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlNil))
            return
        }
        
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.httpResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNil))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([HomeSeriesListModel].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseFailure))
            }
        }
        
        dataTask?.resume()
    }
    
    func searchSeries(query: String, completion: @escaping SearchSeriesCompletionHandler) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.tvmaze.com/search/shows?q=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlNil))
            return
        }
        
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.httpResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNil))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([EmbeddedShow].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseFailure))
            }
        }
        
        dataTask?.resume()
    }
    
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
