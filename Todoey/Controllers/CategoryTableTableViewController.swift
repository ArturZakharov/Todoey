//
//  CategoryTableTableViewController.swift
//  Todoey
//
//  Created by ArturZaharov on 18.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableTableViewController: UITableViewController {
    
    var categoryArray = [ToDoCategory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //let entity = NSEntityDescription.entity(forEntityName: "CategoryTodo", in: context)
        loadData()
    }

    // MARK: - Tableview data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
      
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK:- TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goTOItemsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.choosedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK:- Data manipulation methods
    
    func saveCategoryData(){
        do {
            try context.save()
        } catch {
            print("Error saving Category Context, \(error)")
        }
    }
    
    func loadData(){
        let request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()
        do {
            categoryArray =  try context.fetch(request)
        } catch {
            print("Error fetching category form context")
        }
    }
    
    
    
    //MARK:- Add new category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertDialog = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = ToDoCategory(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            self.saveCategoryData()
            self.tableView.reloadData()
            
        }
        
        alertDialog.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category name"
            textField = alertTextField
        }
        
        alertDialog.addAction(action)
        
        present(alertDialog, animated: true, completion: nil)
        
    }
    
}
