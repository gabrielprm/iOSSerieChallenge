//
//  SeriesDetailsPresenter.swift
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

final class SeriesDetailsPresenter: SeriesDetailsPresenting {
    
    // MARK: - Properties
    
    private let service: SeriesDetailsServicing
    private let coordinator: SeriesDetailsCoordinating
    private let id: Int
    
    weak var viewController: SeriesDetailsDisplaying?
    
    private(set) var serieTitle: String = ""
    
    // MARK: - Initialization
    
    init(
        id: Int,
        service: SeriesDetailsServicing,
        coordinator: SeriesDetailsCoordinating
    ) {
        self.service = service
        self.coordinator = coordinator
        self.id = id
    }
    
    // MARK: - SeriesDetailsPresenting
    
    func fetchSerieDetails() {
        viewController?.showLoader()
        
        service.fetchSerieDetails(id: id) { [weak self] result in
            guard let self = self else { return }
            self.viewController?.hideLoader()
            
            switch result {
            case .success(let model):
                self.handleSerieDetailsSuccess(model: model)
            case .failure(let error):
                debugPrint("Error fetching series details: \(error.errorDescription)")
            }
        }
    }
    
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        service.downloadImage(from: imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    let image = UIImage(data: imageData)
                    completion(image)
                case .failure:
                    completion(nil)
                }
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
    
    func fetchSeasons() {
        service.fetchAllSeasonsFromSeries(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                self.viewController?.presentAllSeasons(model: model)
            case .failure(let error):
                debugPrint("Error fetching seasons: \(error.errorDescription)")
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
                debugPrint("Error fetching episodes: \(error.errorDescription)")
            }
        }
    }
    
    func presentSeasonsSelectionView(seasons: [SerieSeason], delegate: SeasonSelectionDelegate) {
        coordinator.presentSeasonsSelectionView(seasons: seasons, delegate: delegate)
    }
    
    func presentEpisodeDetails(episode: Episode) {
        coordinator.presentEpisodeDetailsScene(episode: episode, serieTitle: serieTitle)
    }
    
    // MARK: - Private Methods
    
    private func handleSerieDetailsSuccess(model: SerieDetails) {
        serieTitle = model.name
        let summary = removePTagsAndBoldTags(from: model.summary)
        let genreString = formatGenreArray(model.genres)
        let scheduleString = formatSchedule(schedule: model.schedule)
        
        downloadImage(url: model.image.imageUrl) { [weak self] image in
            guard let self = self, let image = image else { return }
            
            self.viewController?.setHeaderData(
                image: image,
                title: model.name,
                summary: summary,
                genre: genreString
            )
            self.viewController?.setSchedule(schedule: scheduleString)
        }
    }
    
    private func formatGenreArray(_ genres: [String]) -> String {
        genres.joined(separator: " • ")
    }
    
    private func formatSchedule(schedule: SerieSchedule) -> String {
        let formattedDays = schedule.days.map { String($0.prefix(3)) }
        let joinedDays = formattedDays.joined(separator: ", ")
        var formattedString = "[\(joinedDays)]"
        
        if !schedule.time.isEmpty {
            formattedString += " - \(schedule.time)"
        }
        
        return formattedString
    }
}
