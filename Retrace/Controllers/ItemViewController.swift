//
//  ItemViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {

    var selectedCategory: Category? {
        didSet {
            print("New selectedCategory didSet")
            loadItems()
        }
    }
    
    var incomingItem: Item? {
        didSet {
            print("New incomingItem didSet")
            incomingItem!.parentCategory = selectedCategory
            items.append(incomingItem!)
            self.saveItems()
        }
    }
    var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
        self.tableView.keyboardDismissMode = .onDrag
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.SegueIdentifiers.makerSegue, sender: self)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.itemIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
            destinationVC.incomingItem = items[indexPath.row]
        }
    }
}

//MARK: - Updating Data

extension ItemViewController {
    func saveItems() {
        do {
            try K.context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var predicates = [NSPredicate]()
        if predicate != nil {
            predicates.append(predicate!)
        }

        predicates.append(NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!))
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compoundPredicate
        
        do {
            items = try K.context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        print(items)
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
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        var predicate: NSPredicate? = nil
        
        if searchText.count != 0 {
            predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        }
        
        loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()
    }
}
