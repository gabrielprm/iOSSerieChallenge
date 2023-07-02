//
//  MovieListPresenter.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation
import UIKit

protocol SeriesDetailsPresenting {
    func fetchSerieDetails()
    func fetchSeasons()
    func fetchEpisodes(seasonID: Int)
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void)
    func removePTagsAndBoldTags(from htmlString: String) -> String
    func presentSeasonsSelectionView(seasons: [SerieSeason], delegate: SeasonSelectionDelegate)
    func presentEpisodeDetails(episode: Episode)
}

class SeriesDetailsPresenter: SeriesDetailsPresenting {
    let service: SeriesDetailsServicing
    let coordinator: SeriesDetailsCoordinating
    
    weak var viewController: SeriesDetailsDisplaying?
    
    let id: Int
    
    init(id: Int, service: SeriesDetailsServicing, coordinator: SeriesDetailsCoordinating) {
        self.service = service
        self.coordinator = coordinator
        self.id = id
    }
    
    func fetchSerieDetails() {
        service.fetchSerieDetails(id: id) { [weak self] result in
            switch result {
            case .success(let model):
                let summary = self?.removePTagsAndBoldTags(from: model.summary)
                guard let summary = summary else { return }
                self?.downloadImage(url: model.image.imageUrl) { image in
                    if let image = image {
                        self?.viewController?.setHeaderData(image: image, title: model.name, summary: summary)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        service.downloadImage(from: imageURL) { result in
            switch result {
            case .success(let imageData):
                let image = UIImage(data: imageData)
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func removePTagsAndBoldTags(from htmlString: String) -> String {
        var processedString = htmlString
        
        processedString = processedString.replacingOccurrences(of: "<p>", with: "")
        processedString = processedString.replacingOccurrences(of: "</p>", with: "")
        processedString = processedString.replacingOccurrences(of: "<b>", with: "")
        processedString = processedString.replacingOccurrences(of: "</b>", with: "")
        
        return processedString
    }
    
    func fetchSeasons() {
        service.fetchAllSeasonsFromSeries(id: id) { [weak self] result in
            switch result {
            case .success(let model):
                self?.viewController?.presentAllSeasons(model: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchEpisodes(seasonID: Int) {
        service.fetchAllEpisodesFromSeason(id: seasonID) { [weak self] result in
            switch result {
            case .success(let model):
                self?.viewController?.presentAllEpisodesFromSeason(episodes: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentSeasonsSelectionView(seasons: [SerieSeason], delegate: SeasonSelectionDelegate) {
        coordinator.presentSeasonsSelectionView(seasons: seasons, delegate: delegate)
    }
    
    func presentEpisodeDetails(episode: Episode) {
        coordinator.presentEpisodeDetailsScene(episode: episode)
    }
}
