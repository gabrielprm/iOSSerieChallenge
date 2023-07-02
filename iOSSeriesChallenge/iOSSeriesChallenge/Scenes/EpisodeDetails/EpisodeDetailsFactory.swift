//
//  EpisodeDetailsFactory.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import Foundation
import UIKit

enum EpisodeDetailsFactory {
    static func make(episode: Episode) -> UIViewController {
        let presenter = EpisodeDetailsPresenter(episode: episode)
        let viewController = EpisodeDetailsViewController(presenter: presenter)
        
        viewController.hidesBottomBarWhenPushed = true
        
        presenter.viewController = viewController
        
        return viewController
    }
}
