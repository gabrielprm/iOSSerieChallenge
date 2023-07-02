//
//  SeriesDetailsCoordinator.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//
import Foundation
import UIKit

protocol SeriesDetailsCoordinating: AnyObject {
    func presentSeasonsSelectionView(seasons: [SerieSeason], delegate: SeasonSelectionDelegate)
    func presentEpisodeDetailsScene(episode: Episode)
}

final class SeriesDetailsCoordinator: SeriesDetailsCoordinating {
    weak var viewController: UIViewController?
    
    func presentSeasonsSelectionView(seasons: [SerieSeason], delegate: SeasonSelectionDelegate) {
        let seasonSelectionVC = SeasonSelectionFactory.make(seasons: seasons)
        seasonSelectionVC.delegate = delegate
        viewController?.navigationController?.pushViewController(seasonSelectionVC, animated: true)
    }
    
    func presentEpisodeDetailsScene(episode: Episode) {
        let episodeDetailsVC = EpisodeDetailsFactory.make(episode: episode)
        viewController?.navigationController?.pushViewController(episodeDetailsVC, animated: true)
    }
}
