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
        return section == 0 ? Cart.current.products.count : 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell

//        let product = Cart.current.products[indexPath.row]
//        let offer = product.product.offers.first { $0.productOfferID == product.offerID }!
//        let productVM = (product.product)
//        
//        cell.imageURL = product.product.mainImage
//        cell.nameLabel.text = product.product.name
//
//        let sizeAttributedString = NSMutableAttributedString(string: "Размер: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
//        sizeAttributedString.append(NSAttributedString(string: offer.size, attributes: [NSAttributedString.Key.foregroundColor: UIColor.label]))
//
//        cell.oldPriceLabel.text = productVM.oldPrice
//        cell.currentPriceLabel.text = productVM.price
//
//        cell.sizeLabel.attributedText = NSAttributedString(attributedString: sizeAttributedString)
        
        return cell
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
        
//        switch segue.identifier {
//        case "Select Product":
//
//            let cell = sender as! UITableViewCell
//            let indexPath = tableView.indexPath(for: cell)!
//            let product = Cart.current.products[indexPath.row]
//
//            let vc = segue.destination as! ProductViewController
//            vc.productID = product.product.id!
//
//        default:
//            break
//        }
        
    }
    
}
