//
//  SeriesListViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

protocol SeriesListDisplaying: AnyObject {
    func displaySeries(series: [EmbeddedShow])
    func showLoader()
    func hideLoader()
}

final class SeriesListViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let scrollThreshold: CGFloat = 500
        static let searchBarHeight: CGFloat = 44
        static let searchBarHorizontalPadding: CGFloat = 10
    }
    
    // MARK: - Properties
    
    private var serieList: [EmbeddedShow] = []
    private var searchData = ""
    private let presenter: SeriesListPresenting
    private let layout = TwoColumnFlowLayout()
    
    // MARK: - UI Components
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(
            x: Constants.searchBarHorizontalPadding,
            y: 0,
            width: view.bounds.size.width - Constants.searchBarHorizontalPadding * 2,
            height: Constants.searchBarHeight
        ))
        searchBar.barStyle = .black
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(
            SeriesListCollectionViewCell.self,
            forCellWithReuseIdentifier: SeriesListCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Initialization
    
    init(presenter: SeriesListPresenting) {
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
        presenter.fetchSeries()
    }
    
    // MARK: - Private Methods
    
    private func configureViews() {
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
}

// MARK: - SeriesListDisplaying

extension SeriesListViewController: SeriesListDisplaying {
    func displaySeries(series: [EmbeddedShow]) {
        serieList += series
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.view.isUserInteractionEnabled = true
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension SeriesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SeriesListCollectionViewCell.identifier,
            for: indexPath
        ) as? SeriesListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let series = serieList[indexPath.item]
        let placeholderImage = UIImage(named: "imagePlaceholder")
        
        cell.setupCell(title: series.show.name, image: placeholderImage)
    
        presenter.downloadImage(url: series.show.image?.imageUrl) { [weak self] image in
            guard let self = self,
                  let image = image,
                  indexPath.item < self.serieList.count else { return }
            cell.setupCell(title: self.serieList[indexPath.item].show.name, image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.navigateToDetailsPage(id: serieList[indexPath.item].show.id)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let maximumOffsetY = scrollView.contentSize.height - scrollView.frame.height
        
        if maximumOffsetY - contentOffsetY <= Constants.scrollThreshold && contentOffsetY > 0 {
            presenter.updateSeriesData()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SeriesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            presenter.fetchSeries()
            searchBar.resignFirstResponder()
            return
        }
        performSearch(with: searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        serieList = []
        presenter.fetchSeries()
    }
    
    private func performSearch(with searchText: String) {
        serieList = []
        searchData = searchText
        presenter.searchSerie(query: searchText)
    }
}
