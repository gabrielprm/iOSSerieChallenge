//
//  MovieListService.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation


protocol SeriesDetailsServicing {
    typealias serieDetailsCompletionHandler = (Result<SerieDetails, ServiceSeriesListErrors>) -> Void
    func fetchSerieDetails(id: Int, completion: @escaping serieDetailsCompletionHandler)
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
}
