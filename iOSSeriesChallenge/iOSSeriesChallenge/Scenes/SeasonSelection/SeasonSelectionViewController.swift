//
//  SeasonSelectionViewController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import UIKit

protocol SeasonSelectionDelegate: AnyObject {
    func selectSeason(season: SerieSeason)
}

final class SeasonSelectionViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellIdentifier = "SeasonCell"
        static let topPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
    }
    
    // MARK: - Properties
    
    private let seasons: [SerieSeason]
    weak var delegate: SeasonSelectionDelegate?
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.backgroundColor = UIColor(named: "DarkBlue")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Initialization

    init(seasons: [SerieSeason]) {
        self.seasons = seasons
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        view.backgroundColor = UIColor(named: "DarkBlue")
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func configureNavigationBar() {
        title = "Season Selection"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension SeasonSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Season \(seasons[indexPath.row].number)"
        cell.textLabel?.textColor = UIColor(named: "Cream")
        cell.backgroundColor = UIColor(named: "DarkestBlue")
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SeasonSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectSeason(season: seasons[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}
