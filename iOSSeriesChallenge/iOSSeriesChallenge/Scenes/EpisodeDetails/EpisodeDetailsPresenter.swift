//
//  EpisodeDetailsPresenter.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import Foundation
import UIKit

protocol EpisodeDetailsPresenting {
    func presentData()
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void)
    func removePTagsAndBoldTags(from htmlString: String) -> String
}

class EpisodeDetailsPresenter: EpisodeDetailsPresenting {
    let service: EpisodeDetailsServicing
    
    weak var viewController: EpisodeDetailsDisplaying?
    
    let episode: Episode
    let serieTitle: String
    
    init(service: EpisodeDetailsServicing, episode: Episode, serieTitle: String) {
        self.service = service
        self.episode = episode
        self.serieTitle = serieTitle
    }
    
    func presentData() {
        var newEpisodeData = episode
        newEpisodeData.summary = removePTagsAndBoldTags(from: episode.summary ?? "")
        viewController?.displayData(episode: newEpisodeData, serieTitle: serieTitle)
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
}
