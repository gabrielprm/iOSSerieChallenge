//
//  SeriesDetailsService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

protocol SeriesDetailsServicing {
    typealias SerieDetailsCompletionHandler = (Result<SerieDetails, ServiceSeriesListErrors>) -> Void
    typealias DownloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    typealias SerieSeasonsCompletionHandler = (Result<[SerieSeason], ServiceSeriesListErrors>) -> Void
    typealias SeasonEpisodesCompletionHandler = (Result<[Episode], ServiceSeriesListErrors>) -> Void
    
    func fetchSerieDetails(id: Int, completion: @escaping SerieDetailsCompletionHandler)
    func downloadImage(from url: URL, completion: @escaping DownloadImageCompletionHandler)
    func fetchAllSeasonsFromSeries(id: Int, completion: @escaping SerieSeasonsCompletionHandler)
    func fetchAllEpisodesFromSeason(id: Int, completion: @escaping SeasonEpisodesCompletionHandler)
}

final class SeriesDetailsService: SeriesDetailsServicing {
    private let session: SessionRequest
    
    init(session: SessionRequest = URLSession.shared) {
        self.session = session
    }
    
    func fetchSerieDetails(id: Int, completion: @escaping SerieDetailsCompletionHandler) {
        let urlString = "https://api.tvmaze.com/shows/\(id)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlNil))
            return
        }
        
        session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.httpResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNil))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(SerieDetails.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseFailure))
            }
        }.resume()
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
    
    func fetchAllSeasonsFromSeries(id: Int, completion: @escaping SerieSeasonsCompletionHandler) {
        let urlString = "https://api.tvmaze.com/shows/\(id)/seasons"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlNil))
            return
        }
        
        session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.httpResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNil))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([SerieSeason].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseFailure))
            }
        }.resume()
    }
    
    func fetchAllEpisodesFromSeason(id: Int, completion: @escaping SeasonEpisodesCompletionHandler) {
        let urlString = "https://api.tvmaze.com/seasons/\(id)/episodes"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlNil))
            return
        }
        
        session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.httpResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNil))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Episode].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseFailure))
            }
        }.resume()
    }
}
