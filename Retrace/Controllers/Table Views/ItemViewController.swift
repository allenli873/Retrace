//
//  ItemViewController.swift
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

class ItemTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
}

//MARK: - Item View Controller: Tabulates Items

class ItemViewController: SwipeTableViewController {
    var items: Results<Item>?
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    var imagePickerController: UIImagePickerController!
    var oldColor: UIColor?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
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
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = self.navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        if let hex = selectedCategory?.hexValue {
            self.navigationItem.title = selectedCategory!.name
            guard let color = UIColor.init(hexString: hex) else {
                print("Error: hex doesn't work")
                return
            }
            searchBar.barTintColor = color
            oldColor = navBar.barTintColor
            setNavigationColor(with: color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // restore the original color of the nav bar
        let color = self.traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        setNavigationColor(with: color)
    }
    
    func setNavigationColor(with color: UIColor) {
        guard let navBar = self.navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        // customizing navigation bar color, fixing iOS 13.4 bug
        let contrastColor = ContrastColorOf(color, returnFlat: true)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.largeTitleTextAttributes = [.foregroundColor: contrastColor]
            appearance.titleTextAttributes = [.foregroundColor: contrastColor]
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.compactAppearance = appearance
        } else {
            navBar.barTintColor = color
            navBar.largeTitleTextAttributes = [.foregroundColor: contrastColor]
            navBar.titleTextAttributes = [.foregroundColor: contrastColor]
        }
        navBar.tintColor = contrastColor
        addButton.tintColor = contrastColor
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        photoTaking()
    }
    
    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items?[indexPath.row].name ?? "No Items Added"
        if let hex = selectedCategory?.hexValue {
            let bgColor = UIColor.init(hexString: hex)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items?.count ?? 1))!
            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    //MARK: - Segue Preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue to where we can view the image
        if segue.identifier == K.SegueIdentifiers.imageSegue {
            let destinationVC = segue.destination as! ImageViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("error: no index path found")
                return
            }
            destinationVC.incomingItem = items?[indexPath.row]
        } else {
            prepareCustomizerVC(for: segue, sender)
        }
    }
}

//MARK: - UITableViewDelegate

extension ItemViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.SegueIdentifiers.imageSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
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
