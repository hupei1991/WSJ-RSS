//
//  RSSFeedTableViewController.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import UIKit

class RSSFeedTableViewController: UITableViewController {
    private let presenter = RSSFeedPresenter()
    private var feeds = [RSSFeed]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(with: self)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.tableFooterView = UIView(frame: frame)
        
        self.tableView.estimatedRowHeight = 150
        
        
        self.presenter.getFeeds()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter.requestTitle()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSFeedTableViewCell", for: indexPath)

        // Configure the cell...
        let feed = self.feeds[indexPath.row]
        if let cell = cell as? RSSFeedTableViewCell {
            cell.feedTitle.text = feed.title
            cell.feedDescription.text = feed.description
            cell.pubDate.text = feed.pubdate
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = self.feeds[indexPath.row]
        if let url = URL(string: feed.link) {
            let viewController = CommonWebViewController(url)
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Failure", message: "Failed to open this feed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

extension RSSFeedTableViewController {
    func setChannel(with channel: RSSChannel) {
        self.presenter.sourceChannel = channel
    }
}

extension RSSFeedTableViewController: FeedView {
    func startLoading() {
        print("start loading")
    }
    
    func finishLoading() {
        print("finished loading")
    }
    
    func receivedFeeds(with feeds: [RSSFeed]) {
        print("received \(feeds.count) feeds")
        self.feeds = feeds
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func parsingFailed(error: XMLFeedParseError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failure", message: "Failed in getting feeds", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func receivedTitle(with title: String) {
        self.navigationItem.title = title
    }
}
