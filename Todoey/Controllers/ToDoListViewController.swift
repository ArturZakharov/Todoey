//
//  ViewController.swift
//  Todoey
//
//  Created by ArturZaharov on 14.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{
    
    @IBOutlet var toDoListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        title = choosedCategory?.name
        guard let colorHex = choosedCategory?.color else {fatalError()}
        updateNavBar(with: colorHex)
        
        guard let navBarColor = UIColor(hexString: colorHex) else {fatalError()}
        searchBar.barTintColor = navBarColor
        searchBar.searchTextField.backgroundColor = UIColor.white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(with: "1D9BF6")
    }
    
    //MARK:- Nav Bar setup Methods
    
    func updateNavBar(with hexColor: String){
        let updateNavBar = UpdateNavigationController()
        updateNavBar.updateNavBar(hexColor: hexColor, context: self, navController: navigationController)
    }
    
    //MARK: - Tableview datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            let parentColor = UIColor(hexString: choosedCategory!.color)
            if let color = parentColor?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count) / 1.4){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
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
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                self.save(item: newItem)
                
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new iteam"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true){
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertOnTapOutside)))
        }
    }
    
    @objc func dismissAlertOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        //The wrong way to do it, because you deleting item only from category but in items its stays, its not good
//        if let currentCategory = self.choosedCategory {
//            do {
//                try self.realm.write({
//                    currentCategory.items.remove(at: indexPath.row)
//                })
//            } catch {
//                print("Error savimg Item to parentCategory, \(error)")
//            }
//        }
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    func save(item: Item){
        if let currentCategory = self.choosedCategory {
            do {
                try self.realm.write({
                    currentCategory.items.append(item)
                })
            } catch {
                print("Error savimg Item to parentCategory, \(error)")
            }
        }
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
