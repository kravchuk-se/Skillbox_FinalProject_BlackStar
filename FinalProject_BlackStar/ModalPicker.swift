//
//  ModalPicker.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 15.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

protocol ModalPickerDelegate: class {
    func didSelectValue()
}

class ModalPicker: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    weak var delegate: ModalPickerDelegate?
    
    var options: [(String, String, Bool)] = [("XS","1 шт.", false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        heightConstraint.constant = CGFloat(options.count) * tableView.rowHeight + 40.0
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
        
        
        //delegate?.didSelectValue()
    }
    
}

extension ModalPicker: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? options.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath)
        
        return cell
        
    }
}


