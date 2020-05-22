//
//  ViewController.swift
//  Todoey
//
//  Created by ArturZaharov on 14.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    @IBOutlet var toDoListTableView: UITableView!
    
    var toDoItems: Results<Item>?
    
    var choosedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added yet"
        }
        
        
        
        
        return cell
    }
    
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    //for deleting object from Realm
                    //realm.delete(item)
                    item.done = !item.done
                })
            } catch {
                print("Error changing done status, \(error)")
            }
        }
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //or like this for removing this item from core data
        //first this
        //context.delete(itemArray[indexPath.row])
        //and then this. Its very important
        //itemArray.remove(at: indexPath.row)
        //        saveItemData()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new iteams to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            print("succses")
            
            if textField.text != "" {
                if let currentCategory = self.choosedCategory {
                    do {
                        try self.realm.write({
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        })
                    } catch {
                        print("Error savimg Item to parentCategory, \(error)")
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new iteam"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadData(){
//        if let items = choosedCategory?.items {
//            toDoItems = items.sorted(byKeyPath: "title ", ascending: true)
//            print("All is good")
//        }
        toDoItems = choosedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}


//MARK:- SearchBar metods
extension ToDoListViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData() 
            
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            loadData(with: request, predicate: predicate)
//

        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
