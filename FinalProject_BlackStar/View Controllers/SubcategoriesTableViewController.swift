//
//  SubcategoriesTableViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class SubcategoriesTableViewController: UITableViewController {

    var subcategoriesController: SubcategoriesController!
    var category: Category!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subcategoriesController = SubcategoriesController(categoryID: category.id)
        
        navigationItem.title = category.name
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? subcategoriesController.numberOfObjects : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        cell.configure(with: subcategoriesController.object(at: indexPath.row))
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        switch segue.identifier {
        case "Select Category":
            
            let vc = segue.destination.content as! ProductsCollectionViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            
            vc.subcategory = subcategoriesController.object(at: indexPath.row)
            
        default:
            break
        }

    }
    
}
