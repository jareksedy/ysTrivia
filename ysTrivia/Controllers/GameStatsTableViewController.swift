//
//  GameStatsTableViewController.swift
//  ysTrivia
//
//  Created by Ярослав on 19.09.2021.
//

import UIKit

class GameStatsTableViewController: UITableViewController {
    
    let statsService = StatsService()
    var data: [GameStats]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        data = statsService.fetch()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        guard let stats = data?[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.font = UIFont.monospacedSystemFont(ofSize: 10.0, weight: UIFont.Weight.regular)
        cell.textLabel!.text = stats.text.uppercased()
        
        return cell
    }
    
    
}
