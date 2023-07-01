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
                self?.viewController?.setSeriesTitleAndSummary(title: model.name, summary: summary)
            case .failure(let error):
                print(error)
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
