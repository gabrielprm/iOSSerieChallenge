//
//  MovieListViewController.swift
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

class SeriesListViewController: UIViewController {
    var serieList: [EmbeddedShow] = []
    var index = 0
    var searchData = ""
    
    let layout = TwoColumnFlowLayout()
    
    var presenter: SeriesListPresenting
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 10, y: 0, width: view.bounds.size.width - 20, height: 44))
        searchBar.barStyle = .black
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(SeriesListCollectionViewCell.self, forCellWithReuseIdentifier: SeriesListCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(presenter: SeriesListPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()

        presenter.fetchSeries()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
    }
    
    func configureViews() {
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
}

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

extension SeriesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serieList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeriesListCollectionViewCell.identifier, for: indexPath) as! SeriesListCollectionViewCell
        
        cell.setupCell(title: serieList[indexPath.item].show.name, image: UIImage(named: "imagePlaceholder")!)
    
        presenter.downloadImage(url: serieList[indexPath.item].show.image?.imageUrl) { [weak self] image in
            if let image = image {
                cell.setupCell(title: self?.serieList[indexPath.item].show.name, image: image)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.navigateToDetailsPage(id: serieList[indexPath.item].show.id)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 500 // Adjust this threshold based on your needs
        
        let contentOffsetY = scrollView.contentOffset.y
        let maximumOffsetY = scrollView.contentSize.height - scrollView.frame.height
        
        if maximumOffsetY - contentOffsetY <= threshold && contentOffsetY > 0 {
             presenter.updateSeriesData()
        }
    }
}

extension SeriesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            performSearch(with: searchText)
            return
        }
        presenter.fetchSeries()
        searchBar.resignFirstResponder()
    }
    
    func performSearch(with searchText: String) {
        serieList = []
        searchData = searchText
        
        if searchText != "" {
            presenter.searchSerie(query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.fetchSeries()
    }
}
