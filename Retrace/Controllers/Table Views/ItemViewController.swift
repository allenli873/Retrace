//
//  ItemViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: - Item View Controller: Tabulates Items

class ItemViewController: SwipeTableViewController {
    var items: Results<Item>?
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    var imagePickerController: UIImagePickerController!
    // from category view controller: loads items into items variable
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // incoming item from ImageViewController
    var incomingItem: Item? {
        didSet {
            self.saveItem(with: incomingItem!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
        if defaults.object(forKey: K.imageCountKey) == nil {
            defaults.set(0, forKey: K.imageCountKey)
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        photoTaking()
    }
    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items?[indexPath.row].name ?? "No Items Added"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

}

//MARK: - UITableViewDelegate

extension ItemViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SegueIdentifiers.imageSegue, sender: self)
    }
}

//MARK: - Data Manipulation Methods

extension ItemViewController {
    func saveItem(with item: Item) {
        do {
            try realm.write {
                selectedCategory?.items.append(incomingItem!)
                realm.add(item)
            }
        } catch {
            print("Error saving item, \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteData(at indexPath: IndexPath) {
        guard let item = items?[indexPath.row] else {
            return
        }
        do {
            try realm.write {
               realm.delete(item)
            }
        } catch {
            print("Error deleting item: \(error)")
        }
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
    }
}

//MARK: - UISearchBarDelegate

extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        if searchBar.text!.count != 0 {
            self.items = self.items?.filter(predicate).sorted(byKeyPath: "name", ascending: true)
        } else {
            loadItems()
        }
        tableView.reloadData()
    }
}
