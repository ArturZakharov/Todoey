//
//  ViewController.swift
//  Todoey
//
//  Created by ArturZaharov on 14.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{

    @IBOutlet var toDoListTableView: UITableView!
    
    var itemArray = ["milk", "cleanin", "go home","milk1", "cleanin1", "go home1","milk2", "cleanin2", "go home2","milk3", "cleanin3", "go home3","milk4", "cleanin4", "go home4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Tableview datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new iteams to list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            print("succses")
            
            if textField.text == "" {
                return
            } else {
                self.itemArray.append(textField.text!)
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
    


}

