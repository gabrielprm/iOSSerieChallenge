//
//  SeriesDetailsFactory.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation
import UIKit

enum SeriesDetailsFactory {
    static func make(id: Int) -> UIViewController {
        let service = SeriesDetailsService()
        let coordinator = SeriesDetailsCoordinator()
        let presenter = SeriesDetailsPresenter(id: id, service: service, coordinator: coordinator)
        let viewController = SeriesDetailsViewController(presenter: presenter)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        
        return viewController
    }
}
