//
//  SeasonSelectionBottomSheet.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import UIKit
protocol SeasonSelectionDelegate: AnyObject {
    func selectSeason(season: SerieSeason)
}

class SeasonSelectionViewController: UIViewController {
    private var seasons: [SerieSeason] = []
    
    weak var delegate: SeasonSelectionDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.darkGray
        return tableView
    }()

    init(seasons: [SerieSeason]) {
        self.seasons = seasons
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Season Selection"
        view.backgroundColor = .darkGray
        tableView.dataSource = self
        tableView.delegate = self
        
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureView() {
        
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

extension SeasonSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Season \(seasons[indexPath.row].number)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .darkGray
        return cell
    }
}

extension SeasonSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectSeason(season: seasons[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}
