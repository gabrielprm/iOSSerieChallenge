//
//  MovieListViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

protocol SeriesListPresenterView: AnyObject {
    func displaySeries(name: String, image: UIImage?)
}

extension SeriesListViewController.Layout {
    enum Spacing {
        static let collectionViewLeadingTrailing: CGFloat = 10
    }
}

class SeriesListViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate enum Layout { }
    
    var serieList: [(String, UIImage?)] = []
    
    let layout = TwoColumnFlowLayout()
    
    var presenter: SeriesListPresenterProtocol
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(SeriesListCollectionViewCell.self, forCellWithReuseIdentifier: "SeriesListCollectionViewCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(presenter: SeriesListPresenterProtocol) {
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
        presenter.fetchSeries()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureViews() {
        view.addSubview(collectionView)
    }
    
    func setupContraints() {
        
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serieList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesListCollectionViewCell", for: indexPath) as! SeriesListCollectionViewCell
        cell.setupCell(title: serieList[indexPath.item].0, image: serieList[indexPath.item].1 ?? UIImage(named: "imagePlaceholder2"))

        return cell
    }
}

extension SeriesListViewController: SeriesListPresenterView {
    func displaySeries(name: String, image: UIImage?) {
        serieList.append((name, image))
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
