//
//  EpisodeDetailsPresenter.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import Foundation

protocol EpisodeDetailsPresenting { }

class EpisodeDetailsPresenter: EpisodeDetailsPresenting {
    weak var viewController: EpisodeDetailsDisplaying?
    
    let episode: Episode
    
    init(episode: Episode) {
        self.episode = episode
    }
}
