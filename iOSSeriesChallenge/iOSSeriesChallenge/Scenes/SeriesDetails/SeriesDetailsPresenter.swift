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
    func removePTagsAndBoldTags(from htmlString: String?) -> String
    func presentSeasonsSelectionView(seasons: [SerieSeason], delegate: SeasonSelectionDelegate)
    func presentEpisodeDetails(episode: Episode)
}

class SeriesDetailsPresenter: SeriesDetailsPresenting {
    let service: SeriesDetailsServicing
    let coordinator: SeriesDetailsCoordinating
    
    weak var viewController: SeriesDetailsDisplaying?
    
    let id: Int
    var serieTitle: String = ""
    
    init(id: Int, service: SeriesDetailsServicing, coordinator: SeriesDetailsCoordinating) {
        self.service = service
        self.coordinator = coordinator
        self.id = id
    }
    
    func fetchSerieDetails() {
        viewController?.showLoader()
        service.fetchSerieDetails(id: id) { [weak self] result in
            guard let self = self else { return }
            self.viewController?.hideLoader()
            switch result {
            case .success(let model):
                self.serieTitle = model.name
                let summary = self.removePTagsAndBoldTags(from: model.summary)
                self.downloadImage(url: model.image.imageUrl) { image in
                    if let image = image {
                        self.viewController?.setHeaderData(image: image, title: model.name, summary: summary, genre: self.returnGenreArrayString(array: model.genres))
                        self.viewController?.setSchedule(schedule: self.formatSchedule(schedule: model.schedule))
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
    
    func removePTagsAndBoldTags(from htmlString: String?) -> String {
        guard let htmlString = htmlString else { return "" }
        
        var processedString = htmlString
    
        processedString = processedString.replacingOccurrences(of: "<p>", with: "")
        processedString = processedString.replacingOccurrences(of: "</p>", with: "")
        processedString = processedString.replacingOccurrences(of: "<b>", with: "")
        processedString = processedString.replacingOccurrences(of: "</b>", with: "")
          
        return processedString
    }
    
    func returnGenreArrayString(array: [String]) -> String {
        array.joined(separator: " • ")
    }
    
    func formatSchedule(schedule: SerieSchedule) -> String {
        let formattedDays = schedule.days.map { day -> String in
            let dayPrefix = String(day.prefix(3))
            return dayPrefix
        }

        let joinedDays = formattedDays.joined(separator: ", ")
        var formattedString = "[\(joinedDays)]"

        if !schedule.time.isEmpty {
            formattedString += " - \(schedule.time)"
        }
        return formattedString
    }
    
    func fetchSeasons() {
        service.fetchAllSeasonsFromSeries(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.viewController?.presentAllSeasons(model: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchEpisodes(seasonID: Int) {
        viewController?.showLoader()
        service.fetchAllEpisodesFromSeason(id: seasonID) { [weak self] result in
            guard let self = self else { return }
            self.viewController?.hideLoader()
            switch result {
            case .success(let model):
                self.viewController?.presentAllEpisodesFromSeason(episodes: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentSeasonsSelectionView(seasons: [SerieSeason], delegate: SeasonSelectionDelegate) {
        coordinator.presentSeasonsSelectionView(seasons: seasons, delegate: delegate)
    }
    
    func presentEpisodeDetails(episode: Episode) {
        coordinator.presentEpisodeDetailsScene(episode: episode, serieTitle: serieTitle)
    }
}
