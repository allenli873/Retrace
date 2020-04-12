//
//  ViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit
import ShadowView

class CategoryTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowView: ShadowView!
    
}

//MARK: - Category View Controller: Tabulates the categories

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
        
    }
    
    //MARK: - Add Button Pressed: Segue to Item View Controller
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let text = textField.text!
            // do nothing if user does not enter text
            if text == "" {
                return
            }
            
            let newCategory = Category()
            newCategory.name = text
            newCategory.hexValue = UIColor.randomFlat().hexValue()
            self.saveData(with: newCategory)
            
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: - Data Manipulation Methods

extension CategoryViewController {
    func saveData(with category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
    }
    
    func deleteData(at indexPath: IndexPath) {
        guard let category = categories?[indexPath.row] else {
            return
        }
        do {
            try realm.write {
               realm.delete(category)
            }
        } catch {
            print("Error deleting category: \(error)")
        }
    }
    
    func loadData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}

//MARK: - Table View Data Source Methods

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAt: indexPath) as! CategoryTableViewCell
        let currentCategory = categories?[indexPath.row]
        cell.nameLabel.text = currentCategory?.name ?? "No Categories Added Yet"
        cell.countLabel.text = "\(currentCategory?.items.count ?? 0)"
        if let hex = categories?[indexPath.row].hexValue {
            let bgColor = UIColor.init(hexString: hex)!
            cell = cellDesign(color: bgColor, design: cell)
            
        }
        return cell
    }
    func cellDesign(color bgColor: UIColor, design cell: CategoryTableViewCell) -> CategoryTableViewCell {
        cell.bgView.backgroundColor = bgColor
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.layer.masksToBounds = true
        
        cell.shadowView.backgroundColor = bgColor
        cell.shadowView.layer.cornerRadius = 10
        cell.shadowView.layer.masksToBounds = true
        cell.shadowView.shadowScale = 1.05
        
        cell.countLabel.textColor = ContrastColorOf(bgColor, returnFlat: true)
        cell.nameLabel.textColor = ContrastColorOf(bgColor, returnFlat: true)
        
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Table View Delegate Methods

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SegueIdentifiers.itemsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        destinationVC.selectedCategory = categories?[indexPath.row]
    }
}
