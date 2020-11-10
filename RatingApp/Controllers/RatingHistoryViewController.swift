//
//  RatingHistoryViewController.swift
//  RatingApp
//
//  Created by Raj Raval on 07/11/20.
//

import UIKit
import CoreData

enum Section: CaseIterable {
    case main
}

class RatingHistoryViewController: UITableViewController {
    
    let cellReuseIdentifier = "rating"
    lazy var dataSource = makeDataSource()
    
    var ratings = [RatingItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        
        tableView.register(RatingViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = dataSource
        tableView.rowHeight = 100
        
        fetchRatingItems()
        update(with: ratings)
    }
    
    // MARK: Table View Data Source & Delegates

    func makeDataSource() -> UITableViewDiffableDataSource <Section, RatingItem> {
        return UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, ratingItem in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as? RatingViewCell else {
                fatalError("Error dequeuing cell")
            }
            cell.lowerRatingLabel.text = "Lower Rating: \(ratingItem.lowerValue) "
            cell.upperRatingLabel.text = "Upper Rating: \(ratingItem.upperValue)"
            let dateString = "\(ratingItem.date!.getFormattedDate(format: "MM-dd-yyyy HH:mm"))"
            cell.dateLabel.text = "Created at: \(dateString)"
            cell.selectionStyle = .none
            return cell
        })
    }
    
    func update(with rating: [RatingItem], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RatingItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(rating, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: Core Data Fetch Request
    
    func fetchRatingItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RatingItem")
        do {
            let result = try context.fetch(fetchRequest)
            ratings = result as! [RatingItem]
        } catch let error as NSError {
            print("Error Fetching! \(error)")
        }
    }
}

// MARK: Date Extension

extension Date {
    func getFormattedDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "IST")
        return formatter.string(from: self)
    }
}

