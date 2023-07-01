//
//  MovieListViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

protocol SeriesListDisplaying: AnyObject {
    func displaySeries(id: Int, name: String, image: UIImage?)
}

class SeriesListViewController: UIViewController {
    var serieList: [(Int, String, UIImage?)] = []
    
    let layout = TwoColumnFlowLayout()
    
    var presenter: SeriesListPresenting
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(SeriesListCollectionViewCell.self, forCellWithReuseIdentifier: SeriesListCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
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
    
        title = "Series List"
        
        configureViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        presenter.fetchSeries()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    
    func configureViews() {
        view.addSubview(collectionView)
    }
}

extension SeriesListViewController: SeriesListDisplaying {
    func displaySeries(id: Int, name: String, image: UIImage?) {
        serieList.append((id, name, image))
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
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
        cell.setupCell(title: serieList[indexPath.item].1, image: serieList[indexPath.item].2 ?? UIImage(named: "imagePlaceholder2"))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.navigateToDetailsPage(id: serieList[indexPath.item].0)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
