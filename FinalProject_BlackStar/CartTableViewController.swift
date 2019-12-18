//
//  CartTableViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class CartTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? Cart.current.numberOfItems : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell

        let (product, offer) = Cart.current.object(at: indexPath.row)
         
        cell.imageURL = product.mainImage
        cell.nameLabel.text = product.name

        let sizeAttributedString = NSMutableAttributedString(string: "Размер: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        sizeAttributedString.append(NSAttributedString(string: offer.size, attributes: [NSAttributedString.Key.foregroundColor: UIColor.label]))

        cell.oldPriceLabel.text = product.oldPrice
        cell.currentPriceLabel.text = product.price

        cell.sizeLabel.attributedText = NSAttributedString(attributedString: sizeAttributedString)
        
        return cell
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            Cart.current.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "Select Product":

            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let (product, offer) = Cart.current.object(at: indexPath.row)

            let vc = segue.destination as! ProductViewController
            vc.product = product
            vc.offer = offer

        default:
            break
        }
        
    }
    
}
