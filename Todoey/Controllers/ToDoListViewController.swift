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
    
    let localStorage = UserDefaults.standard
    
    let fileDataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [ToDoItem(titel: "milk"),
                     ToDoItem(titel: "cleanin"),
                     ToDoItem(titel: "go home")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let array = localStorage.array(forKey: "TodoListArray") as? [ToDoItem] {
            itemArray = array
        }
        
        loadData()
        
    }
    
    //MARK: - Tableview datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.toDOTitel
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItemData()
        tableView.reloadData()
        
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
                self.itemArray.append(ToDoItem(titel: textField.text!))
                self.saveItemData()
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
    
    func saveItemData(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: fileDataPath!)
            
        } catch {
            print("Error encoding item array, \(error)")
        }
        
    }
    
    func loadData(){
        if let data = try? Data(contentsOf: fileDataPath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([ToDoItem].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    


}

