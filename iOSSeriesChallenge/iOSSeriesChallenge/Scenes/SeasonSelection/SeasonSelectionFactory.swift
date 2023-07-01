//
//  SeasonSelectionFactory.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import Foundation
import UIKit

enum SeasonSelectionFactory {
    static func make(seasons: [SerieSeason]) -> SeasonSelectionViewController {
        let viewController = SeasonSelectionViewController(seasons: seasons)
        
        viewController.hidesBottomBarWhenPushed = true
        
        return viewController
    }
}
