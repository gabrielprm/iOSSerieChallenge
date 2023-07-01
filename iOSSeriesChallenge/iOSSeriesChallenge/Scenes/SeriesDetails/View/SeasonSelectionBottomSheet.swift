//
//  SeasonSelectionBottomSheet.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 01/07/23.
//

import UIKit

class BottomSheetViewController: UIViewController {
    private let item = ["Season 1", "Season 2", "Season 3"]
    
    private lazy var tableView: UITableView = {
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        configureView()
    }
    
//    private func createTheView() {
//
//        let xCoord = self.view.bounds.width / 2 - 50
//        let yCoord = self.view.bounds.height / 2 - 50
//
//        let centeredView = UIView(frame: CGRect(x: xCoord, y: yCoord, width: 100, height: 100))
//        centeredView.backgroundColor = .blue
//        self.view.addSubview(centeredView)
//    }
    
    private func configureView() {
        view.addSubview(tableView)
    }
}

extension BottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = item[indexPath.row]
        return cell
    }
}

extension BottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if needed
    }
}
