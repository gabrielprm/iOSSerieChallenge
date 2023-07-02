//
//  EpisodeDetailsViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import Foundation
import UIKit

protocol EpisodeDetailsDisplaying: AnyObject {
    func displayData(episode: Episode, serieTitle: String)
}

class EpisodeDetailsViewController: UIViewController {
    var presenter: EpisodeDetailsPresenting
    
    let episodeImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var episodeTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var episodeNumber: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var episodeSeason: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var episodeSummary: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(presenter: EpisodeDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        presenter.presentData()
        view.backgroundColor = .darkGray
    }
    
    func configureViews() {
        view.addSubview(episodeImage)
        view.addSubview(episodeTitle)
        view.addSubview(episodeNumber)
        view.addSubview(episodeSeason)
        view.addSubview(episodeSummary)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            episodeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            episodeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            episodeImage.heightAnchor.constraint(equalToConstant: 144),
            episodeImage.widthAnchor.constraint(equalToConstant: 256),
            
            episodeTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            episodeTitle.topAnchor.constraint(equalTo: episodeImage.bottomAnchor, constant: 20),
            episodeTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            episodeSeason.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            episodeSeason.topAnchor.constraint(equalTo: episodeTitle.bottomAnchor, constant: 5),
            
            episodeNumber.leadingAnchor.constraint(equalTo: episodeSeason.trailingAnchor, constant: 5),
            episodeNumber.topAnchor.constraint(equalTo: episodeTitle.bottomAnchor, constant: 5),
            
            episodeSummary.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            episodeSummary.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            episodeSummary.topAnchor.constraint(equalTo: episodeNumber.bottomAnchor, constant: 10),
        ])
    }
}

extension EpisodeDetailsViewController: EpisodeDetailsDisplaying {
    func displayData(episode: Episode, serieTitle: String) {
        presenter.downloadImage(url: episode.image?.imageUrl ?? "") { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.episodeImage.image = image
                } else {
                    self?.episodeImage.image = UIImage(named: "imagePlaceholder")
                }
            }
        }

        episodeTitle.text = "\(serieTitle) - \(episode.name)"
        episodeSeason.text = "Season \(episode.season)"
        
        if let episodeNumberText = episode.number {
            episodeNumber.text = "- Episode \(episodeNumberText)"
        }
        
        if let summary = episode.summary {
            episodeSummary.text = summary
        }
    }
}
