//
//  SeriesListCoordinator.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import Foundation
import UIKit

protocol SeriesListCoordinating: AnyObject {
    func openDetailsPage(id: Int)
}

final class SeriesListCoordinator: SeriesListCoordinating {
    weak var viewController: UIViewController?
    
    func openDetailsPage(id: Int) {
        let vc = SeriesDetailsFactory.make(id: id)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
