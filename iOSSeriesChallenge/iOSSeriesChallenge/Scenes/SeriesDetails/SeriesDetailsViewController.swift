//
//  MovieListViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 30/06/23.
//

import UIKit

protocol SeriesDetailsDisplaying: AnyObject {
    func setSeriesTitleAndSummary(title: String, summary: String)
}

extension SeriesDetailsViewController.Layout {
    enum Spacing {
        static let collectionViewLeadingTrailing: CGFloat = 10
    }
}

class SeriesDetailsViewController: UIViewController {
    
    fileprivate enum Layout { }
    
    var serieList: [(Int, String, UIImage?)] = []
    
    var presenter: SeriesDetailsPresenting
    
    let seriesImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "imagePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var seriesTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var seriesSummary: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(presenter: SeriesDetailsPresenting) {
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
        presenter.fetchSerieDetails()
        view.backgroundColor = .darkGray
    }
    
    func configureViews() {
        view.addSubview(seriesImage)
        view.addSubview(seriesTitle)
        view.addSubview(seriesSummary)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            seriesImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seriesImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            seriesImage.heightAnchor.constraint(equalToConstant: 250),
            seriesImage.widthAnchor.constraint(equalToConstant: 170),
            
            seriesTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            seriesTitle.topAnchor.constraint(equalTo: seriesImage.bottomAnchor, constant: 20),
            seriesTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            seriesSummary.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            seriesSummary.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            seriesSummary.topAnchor.constraint(equalTo: seriesTitle.bottomAnchor, constant: 5)
        ])
    }
}

extension SeriesDetailsViewController: SeriesDetailsDisplaying {
    func setSeriesTitleAndSummary(title: String, summary: String) {
        DispatchQueue.main.async { [weak self] in
            self?.seriesTitle.text = title
            self?.seriesSummary.text = summary
        }
    }
}
