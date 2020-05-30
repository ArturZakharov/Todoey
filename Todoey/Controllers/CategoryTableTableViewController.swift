//
//  CategoryTableTableViewController.swift
//  Todoey
//
//  Created by ArturZaharov on 18.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let updateNavBar = UpdateNavigationController()
        updateNavBar.updateNavBar(hexColor: "1D9BF6", context: self, navController: navigationController)
    }
    
    // MARK: - Tableview data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "No category added yet"
            cell.backgroundColor = UIColor(hexString: category.color ?? "#FFFFFF")
        }
        return cell
    }
    
    //MARK:- TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goTOItemsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.choosedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK:- Data manipulation methods
    
    func save(category: Category){
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving Category Context, \(error)")
        }
    }
    
    func loadData(){
        //Results<Element> or Results<Element> is the same like Array<String>
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        if let categoryForDeleting = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(categoryForDeleting)
                })
            } catch {
                print("Error deleting category from realm, \(error)")
            }
        }
    }
    
    
    
    //MARK:- Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertDialog = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                let color = UIColor.randomFlat().hexValue()
                newCategory.color = color
                print(color)
                self.save(category: newCategory)
                self.tableView.reloadData()
            }
        }
        
        alertDialog.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category name"
            textField = alertTextField
        }
        
        alertDialog.addAction(action)
       
        present(alertDialog, animated: true){
            alertDialog.view.superview?.isUserInteractionEnabled = true
            alertDialog.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertOnTapOutside)))
        }
    }
    
    @objc func dismissAlertOnTapOutside(){
          self.dismiss(animated: true, completion: nil)
       }
    
}



