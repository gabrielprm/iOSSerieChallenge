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

final class EpisodeDetailsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageHeight: CGFloat = 144
        static let imageWidth: CGFloat = 256
        static let cornerRadius: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 20
        static let smallPadding: CGFloat = 5
        static let titleFontSize: CGFloat = 28
        static let episodeInfoFontSize: CGFloat = 22
        static let summaryFontSize: CGFloat = 14
    }
    
    // MARK: - Properties
    
    private let presenter: EpisodeDetailsPresenting
    
    // MARK: - UI Components
    
    private let episodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var episodeTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor(named: "Cream")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episodeNumber: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.episodeInfoFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episodeSeason: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.episodeInfoFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episodeSummary: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.summaryFontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    init(presenter: EpisodeDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupConstraints()
        presenter.presentData()
        view.backgroundColor = UIColor(named: "DarkBlue")
    }
    
    // MARK: - Private Methods
    
    private func configureViews() {
        view.addSubview(episodeImage)
        view.addSubview(episodeTitle)
        view.addSubview(episodeNumber)
        view.addSubview(episodeSeason)
        view.addSubview(episodeSummary)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            episodeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            episodeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            episodeImage.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            episodeImage.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            
            episodeTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            episodeTitle.topAnchor.constraint(equalTo: episodeImage.bottomAnchor, constant: Constants.topPadding),
            episodeTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            episodeSeason.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            episodeSeason.topAnchor.constraint(equalTo: episodeTitle.bottomAnchor, constant: Constants.smallPadding),
            
            episodeNumber.leadingAnchor.constraint(equalTo: episodeSeason.trailingAnchor, constant: Constants.smallPadding),
            episodeNumber.topAnchor.constraint(equalTo: episodeTitle.bottomAnchor, constant: Constants.smallPadding),
            
            episodeSummary.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            episodeSummary.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            episodeSummary.topAnchor.constraint(equalTo: episodeSeason.bottomAnchor, constant: 10),
        ])
    }
}

// MARK: - EpisodeDetailsDisplaying

extension EpisodeDetailsViewController: EpisodeDetailsDisplaying {
    func displayData(episode: Episode, serieTitle: String) {
        presenter.downloadImage(url: episode.image?.imageUrl ?? "") { [weak self] image in
            self?.episodeImage.image = image ?? UIImage(named: "imagePlaceholder")
        }

        episodeTitle.text = "\(serieTitle) - \(episode.name)"
        episodeSeason.text = "Season \(episode.season)"
        
        if let episodeNumberText = episode.number {
            episodeNumber.text = "- Episode \(episodeNumberText)"
        }
        
        episodeSummary.text = episode.summary
    }
}
