//
//  MovieListPresenter.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import Foundation
import UIKit

protocol SeriesListPresenting {
    func fetchSeries()
    func searchSerie(query: String)
    func updateSeriesData()
    func downloadImage(url: String?, completion: @escaping (UIImage?) -> Void)
    func navigateToDetailsPage(id: Int)
    func setDataToDisplay(fullData: [EmbeddedShow]) -> [EmbeddedShow]
}

class SeriesListPresenter: SeriesListPresenting {
    let service: SeriesListServicing
    let coordinator: SeriesListCoordinating
    weak var viewController: SeriesListDisplaying?
    
    var allSeriesModel: [EmbeddedShow] = []
    var currentDataIndex = 0
    
    init(service: SeriesListServicing, coordinator: SeriesListCoordinating) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func fetchSeries() {
        currentDataIndex = 0
        viewController?.showLoader()
        service.fetchAllSeries { [weak self] result in
            guard let self = self else { return }
            self.viewController?.hideLoader()
            switch result {
            case .success(let model):
                model.forEach { serie in
                    self.allSeriesModel.append(serie._embedded)
                }
                self.updateSeriesData()
            case .failure(_):
                break
            }
        }
    }
    
    func updateSeriesData() {
        currentDataIndex += 1
        let splitedDataSet = setDataToDisplay(fullData: allSeriesModel)
        viewController?.displaySeries(series: splitedDataSet)
    }
    
    func searchSerie(query: String) {
        currentDataIndex = 0
        viewController?.showLoader()
        service.searchSeries(query: query) { [weak self] result in
            guard let self = self else { return }
            self.viewController?.hideLoader()
            switch result {
            case .success(let model):
                self.allSeriesModel = model
                self.updateSeriesData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setDataToDisplay(fullData: [EmbeddedShow]) -> [EmbeddedShow] {
        if fullData.count <= 20 {
            return fullData
        }
        
        let setSize = 20
        let numberOfSets = Int(ceil(Double(fullData.count) / Double(setSize)))
        
        let startIndex = currentDataIndex * setSize
        let endIndex = min(startIndex + setSize, fullData.count)

        let currentDataSet = fullData[startIndex..<endIndex]
        
        return Array(currentDataSet)
    }
    
    func downloadImage(url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url ?? "") else {
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
   
    
    func navigateToDetailsPage(id: Int) {
        coordinator.openDetailsPage(id: id)
    }
}
