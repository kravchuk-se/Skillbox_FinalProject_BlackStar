//
//  CategoriesTableViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var categoriesController = CategoriesController()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesController.delegate = self
        categoriesController.fetch()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        categoriesController.beginObserve()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        categoriesController.stopObserve()
    }
    
    // MARK: - Actions
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        categoriesController.fetch()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? categoriesController.numberOfObjects : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        cell.configure(with: categoriesController.object(at: indexPath.row))
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "Select Category":
            
            let vc = segue.destination as! SubcategoriesTableViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            
            vc.category = categoriesController.object(at: indexPath.row)
            
        default:
            break
        }
        
    }

}

extension CategoriesTableViewController: CategoriesControllerDelegate {
    func didUpdateData(_ controller: CategoriesController, changes: BatchUpdate) {
        
        switch changes {
        case .initial:
            
            break
            
        case .update(let deletions, let insertions, let modifications):
            
            tableView.beginUpdates()
        
            tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
            tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
            tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
            
            tableView.endUpdates()
        
        case .error(let error):
            print(error)
        }
        
    }
    
    func didUpdateData(_ controller: CategoriesController) {
        tableView.reloadData()
    }
    
    func fetchDidBegin(_ controller: CategoriesController) {
        self.refreshControl?.beginRefreshing()
    }
    
    func fetchDidEnd(_ controller: CategoriesController, error: Error?) {
        self.refreshControl?.endRefreshing()
    }
}
