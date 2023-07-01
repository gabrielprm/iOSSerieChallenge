//
//  MovieListService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation

protocol SeriesDetailsServicing {
    typealias serieDetailsCompletionHandler = (Result<SerieDetails, ServiceSeriesListErrors>) -> Void
    typealias downloadImageCompletionHandler = (Result<Data, ServiceSeriesListErrors>) -> Void
    typealias serieSeasonsCompletionHandler = (Result<[SerieSeason], ServiceSeriesListErrors>) -> Void
    typealias seasonEpisodesCompletionHandler = (Result<[Episode], ServiceSeriesListErrors>) -> Void
    
    func fetchSerieDetails(id: Int, completion: @escaping serieDetailsCompletionHandler)
    func downloadImage(from url: URL, completion: @escaping downloadImageCompletionHandler)
    func fetchAllSeasonsFromSeries(id: Int, completion: @escaping serieSeasonsCompletionHandler)
    func fetchAllEpisodesFromSeason(id: Int, completion: @escaping seasonEpisodesCompletionHandler)
}

class SeriesDetailsService: SeriesDetailsServicing {
    private let session: SessionRequest
    
    init(session: SessionRequest = URLSession.shared) {
        self.session = session
    }
    
    func fetchSerieDetails(id: Int, completion: @escaping serieDetailsCompletionHandler) {
        
        let tvMazeUrl = "https://api.tvmaze.com/shows/\(id)"
        
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
                let decodedData = try decoder.decode(SerieDetails.self, from: data)
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
    
    func fetchAllSeasonsFromSeries(id: Int, completion: @escaping serieSeasonsCompletionHandler) {
        let tvMazeUrl = "https://api.tvmaze.com/shows/\(id)/seasons"
        
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
                let decodedData = try decoder.decode([SerieSeason].self, from: data)
                completion(.success(decodedData))
            } catch _ {
                completion(.failure(ServiceSeriesListErrors.parseFailure))
            }
        }.resume()
    }
    
    func fetchAllEpisodesFromSeason(id: Int, completion: @escaping seasonEpisodesCompletionHandler) {
        let tvMazeUrl = "https://api.tvmaze.com/seasons/\(id)/episodes"
        
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
                let decodedData = try decoder.decode([Episode].self, from: data)
                completion(.success(decodedData))
            } catch _ {
                completion(.failure(ServiceSeriesListErrors.parseFailure))
            }
        }.resume()
    }
}
