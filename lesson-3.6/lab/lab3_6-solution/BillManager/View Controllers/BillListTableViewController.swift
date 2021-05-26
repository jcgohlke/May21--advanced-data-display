//
//  BillListTableViewController.swift
//  BillManager
//

import UIKit
import CoreData

private class SwipeableDataSource: UITableViewDiffableDataSource<Int, Bill> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

class BillListTableViewController: UITableViewController {
    
    private let dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        return result
    }()
    
    fileprivate var dataSource: SwipeableDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        dataSource = SwipeableDataSource(tableView: tableView) { tableView, indexPath, bill in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell", for: indexPath)
            
            let bill = Database.shared.bills[indexPath.row]
            
            cell.textLabel?.text = bill.payee
            cell.detailTextLabel?.text = String(format: "$%.2f - Due: %@", arguments: [bill.amount ?? 0, bill.formattedDueDate])
            
            return cell
        }
        
        tableView.dataSource = dataSource
        
        updateSnapshot()
        
        NotificationCenter.default.addObserver(forName: Database.billUpdatedNotification, object: nil, queue: nil) { _ in
            self.updateSnapshot()
        }
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Bill>()
        snapshot.appendSections([0])
        snapshot.appendItems(Database.shared.bills, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, completionHandler) in
            guard let bill = self.dataSource.itemIdentifier(for: indexPath) else { return }
            Database.shared.delete(bill: bill)
            Database.shared.save()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
        
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "billDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath, segue.identifier == "billDetail" {
            let navigationController = segue.destination as? UINavigationController
            let billDetailTableViewController = navigationController?.viewControllers.first as? BillDetailTableViewController
            billDetailTableViewController?.bill = Database.shared.bills[indexPath.row]
        }
    }
    
    @IBAction func unwindFromBillDetail(segue: UIStoryboardSegue) { }
}
