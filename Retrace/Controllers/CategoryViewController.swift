//
//  ViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
    }
    
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
            
            let newCategory = Category(context: K.context)
            newCategory.name = text
            self.categories.append(newCategory)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: - Data Manipulation Methods

extension CategoryViewController {
    func saveData() {
        do {
            try K.context.save()
        } catch {
            print("Error saving category context: \(error)")
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try K.context.fetch(request)
        } catch {
            print("Error fetching category: \(error)")
        }
    }
}

//MARK: - Table View Data Source Methods

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}

