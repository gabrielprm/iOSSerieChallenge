//
//  SeriesListCoordinator.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import UIKit

protocol SeriesListCoordinating: AnyObject {
    func openDetailsPage(id: Int)
}

final class SeriesListCoordinator: SeriesListCoordinating {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - SeriesListCoordinating
    
    func openDetailsPage(id: Int) {
        let detailsViewController = SeriesDetailsFactory.make(id: id)
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
