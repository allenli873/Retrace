//
//  ViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import RealmSwift

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
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            let text = textField.text!
            // do nothing if user does not enter text
            if text == "" {
                return
            }
            
            let newCategory = Category()
            newCategory.name = text
            self.saveData(with: newCategory)
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
}

//MARK: - Table View Delegate Methods

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SegueIdentifiers.itemsSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        destinationVC.selectedCategory = categories?[indexPath.row]
    }
}
