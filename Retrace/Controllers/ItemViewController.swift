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

class ItemViewController: UITableViewController {
    
    var items: Results<Item>?
    let realm = try! Realm()
    // from category view controller: loads items into items array
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    // incoming item from ImageViewController
    var incomingItem: Item? {
        didSet {
//            incomingItem!.parentCategory = selectedCategory
//            items.append(incomingItem!)
            self.saveItems(with: incomingItem!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.SegueIdentifiers.makerSegue, sender: self)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.itemIdentifier, for: indexPath)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // currently not preparing anything for the item segue
        if segue.identifier == K.SegueIdentifiers.makerSegue {
            return
        }
        
        // Segue to where we can view the image
        if segue.identifier == K.SegueIdentifiers.imageSegue {
            let destinationVC = segue.destination as! ImageViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("error: no index path found")
                return
            }
            destinationVC.incomingItem = items?[indexPath.row]
        }
    }
}

//MARK: - Updating Data

extension ItemViewController {
    func saveItems(with item: Item) {
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
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        var predicate: NSPredicate? = nil
//
//        if searchText.count != 0 {
//            predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//        }
//
//        loadItems(with: request, predicate: predicate)
//
//        tableView.reloadData()
    }
}
