//
//  CartTableViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commitOrderButton: UIButton!
    @IBOutlet weak var clearCartButton: UIButton!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var totalSumStackView: UIStackView!
    @IBOutlet weak var emptyCartPlaceholderLabel: UILabel!
    
    var cart: Cart!
    
    // MARK: - View controller's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cart = Cart.current
        
        tableView.dataSource = self
        tableView.delegate = self
        
        clearCartButton.layer.cornerRadius = 5.0
        commitOrderButton.layer.cornerRadius = 5.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Cart.cartUpdateNotification, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        updateUI()
    }
    
    
    // MARK: - Functions
    
    @objc private func updateUI() {
        updateButtonsState()
        updateTotalLabel()
        
        emptyCartPlaceholderLabel.isHidden = !cart.isEmpty
        totalSumStackView.isHidden = cart.isEmpty
    }
    
    private func updateTotalLabel() {
        totalSumLabel.text = ProductPresentation.priceFormatted(cart.total)
    }
    
    func updateButtonsState() {
        clearCartButton.isEnabled = !cart.isEmpty
        commitOrderButton.isEnabled = !cart.isEmpty
    }
    
    // MARK: - Actions
    
    
    
    @IBAction func commitOrderButtonPressed(_ sender: UIButton) {
        
        definesPresentationContext = true
        
        let vc = LoadingViewController()
        vc.successMessage = "Заказ оформлен!"
        present(vc, animated: true, completion: nil)
        
    }
    

    @IBAction func clearCart(_ sender: UIButton) {
        
        while cart.numberOfItems > 0 {
            cart.remove(at: cart.numberOfItems - 1)
        }
        
        tableView.reloadData()
        
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "Select Product":

            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let (product, offer) = cart.object(at: indexPath.row)

            let vc = segue.destination as! ProductViewController
            vc.product = product
            vc.offer = offer

        default:
            break
        }
        
    }
    
}


extension CartViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? cart.numberOfItems : 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell

        let (product, offer) = cart.object(at: indexPath.row)
         
        cell.imageURL = product.mainImage
        cell.nameLabel.text = product.name

        let sizeAttributedString = NSMutableAttributedString(string: "Размер: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        sizeAttributedString.append(NSAttributedString(string: offer.size, attributes: [NSAttributedString.Key.foregroundColor: UIColor.label]))

        cell.oldPriceLabel.text = product.oldPrice
        cell.currentPriceLabel.text = product.price
        cell.currentPriceLabel.textColor = product.oldPrice == nil ? UIColor.label : UIColor.systemRed
        
        cell.sizeLabel.attributedText = NSAttributedString(attributedString: sizeAttributedString)
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           switch editingStyle {
           case .delete:
               
               definesPresentationContext = true
               let vc = ConfirmationViewController()
               vc.color = .systemRed
               vc.setTitle(title: "Удалить товар из корзины?")
               vc.addAction(ConfirmationAction(title: "ОК", style: .ok, handler: { _ in
                   
                self.cart.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .automatic)
                   
               }))
               vc.addAction(ConfirmationAction(title: "Отмена", style: .cancel, handler: nil))
               present(vc, animated: true, completion: nil)
               
               
           default:
               break
           }
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
