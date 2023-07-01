//
//  SeriesListFactory.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation
import UIKit

enum SeriesListFactory {
    static func make() -> UIViewController {
        let service = SeriesListService()
        let coordinator = SeriesListCoordinator()
        let presenter = SeriesListPresenter(service: service, coordinator: coordinator)
        let viewController = SeriesListViewController(presenter: presenter)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        
        return viewController
    }
}
