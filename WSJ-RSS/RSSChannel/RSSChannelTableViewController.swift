//
//  RSSChannelTableViewController.swift
//  WSJ-RSS
//
//  Created by Practice on 10/19/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import UIKit

class RSSChannelTableViewController: UITableViewController {
    
    private let presenter = RSSChannelPresenter()
    var channels: [RSSChannel] = []
    
    private var activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = CGPoint(x: self.tableView.frame.width / 2, y: self.tableView.frame.minX + 40)
        self.view.addSubview(activityIndicator)
        
        self.presenter.attachView(with: self)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.tableFooterView = UIView(frame: frame)
        
        self.tableView.estimatedRowHeight = 100
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.getChannels(_:)), for: .valueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        self.presenter.getChannels()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.channels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSChannelTableViewCell", for: indexPath)

        // Configure the cell...
        let channel = self.channels[indexPath.row]
        if let cell = cell as? RSSChannelTableViewCell {
            cell.channelTitle.text = channel.title
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "RSSFeedTableViewController") as? RSSFeedTableViewController {
            let channel = self.channels[indexPath.row]
            viewController.setChannel(with: channel)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Load Channels
extension RSSChannelTableViewController {
    @objc func getChannels(_ sender: Any) {
        self.presenter.getChannels()
    }
}


extension RSSChannelTableViewController: ChannelView {
    func startLoading() {
        print("start loading channels")
    }
    
    func finishLoading() {
        print("finished loading channels")
        
        DispatchQueue.main.async {
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
            }
            if self.refreshControl?.isRefreshing ?? false {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func setChannels(with channels: [RSSChannel]) {
        self.channels = channels
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}
