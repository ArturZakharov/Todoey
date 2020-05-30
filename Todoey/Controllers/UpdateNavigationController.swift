//
//  updateNavigationController.swift
//  Todoey
//
//  Created by ArturZaharov on 25.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import UIKit
import ChameleonFramework

class UpdateNavigationController {
    
    func updateNavBar (hexColor: String, context: UITableViewController, navController: UINavigationController?){
        guard let navBarColor = UIColor(hexString: hexColor) else {fatalError()}
        
        guard let navBar = navController?.navigationBar else {fatalError("Navigation controller don't exist.")}
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        guard let navigationBar = context.navigationController?.navigationBar else {fatalError()}
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = navBarColor
        navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
