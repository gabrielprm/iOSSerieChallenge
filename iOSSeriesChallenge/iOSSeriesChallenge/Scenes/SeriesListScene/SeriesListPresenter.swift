//
//  SeriesListPresenter.swift
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

final class SeriesListPresenter: SeriesListPresenting {
    
    // MARK: - Constants
    
    private enum Constants {
        static let pageSize = 20
    }
    
    // MARK: - Properties
    
    private let service: SeriesListServicing
    private let coordinator: SeriesListCoordinating
    
    weak var viewController: SeriesListDisplaying?
    
    private(set) var allSeriesModel: [EmbeddedShow] = []
    private(set) var currentDataIndex = 0
    private var isLoading = false
    
    // MARK: - Initialization
    
    init(
        service: SeriesListServicing,
        coordinator: SeriesListCoordinating
    ) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: - SeriesListPresenting
    
    func fetchSeries() {
        guard !isLoading else { return }
        
        currentDataIndex = 0
        allSeriesModel = []
        isLoading = true
        viewController?.showLoader()
        
        service.fetchAllSeries { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.viewController?.hideLoader()
            
            switch result {
            case .success(let model):
                self.allSeriesModel = model.map { $0._embedded }
                self.updateSeriesData()
            case .failure:
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
        guard !isLoading else { return }
        
        currentDataIndex = 0
        allSeriesModel = []
        isLoading = true
        viewController?.showLoader()
        
        service.searchSeries(query: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.viewController?.hideLoader()
            
            switch result {
            case .success(let model):
                self.allSeriesModel = model
                self.updateSeriesData()
            case .failure(let error):
                debugPrint("Search error: \(error.errorDescription)")
            }
        }
    }
    
    func setDataToDisplay(fullData: [EmbeddedShow]) -> [EmbeddedShow] {
        guard fullData.count > Constants.pageSize else {
            return fullData
        }
        
        let startIndex = currentDataIndex * Constants.pageSize
        let endIndex = min(startIndex + Constants.pageSize, fullData.count)
        
        guard startIndex < fullData.count else { return [] }
        
        return Array(fullData[startIndex..<endIndex])
    }
    
    func downloadImage(url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url ?? "") else {
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
   
    func navigateToDetailsPage(id: Int) {
        coordinator.openDetailsPage(id: id)
    }
}
