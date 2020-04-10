//
//  SwipeTableViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/9/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol SwipeTableViewControllerProtocol {
    func deleteData(at indexPath: IndexPath)
}

typealias SwipeTableViewController = SwipeTableViewControllerClass & SwipeTableViewControllerProtocol

class SwipeTableViewControllerClass: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            guard let controller = self as? SwipeTableViewController else {
                return
            }
            controller.deleteData(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
}
