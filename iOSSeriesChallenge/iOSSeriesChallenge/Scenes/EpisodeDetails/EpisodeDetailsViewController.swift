//
//  EpisodeDetailsViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import Foundation
import UIKit

protocol EpisodeDetailsDisplaying: AnyObject { }

class EpisodeDetailsViewController: UIViewController {
    var presenter: EpisodeDetailsPresenting
    
    init(presenter: EpisodeDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension EpisodeDetailsViewController: EpisodeDetailsDisplaying {
    
}
