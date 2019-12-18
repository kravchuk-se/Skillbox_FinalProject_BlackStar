//
//  ModalPicker.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 15.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

typealias ModalPickerOption = (id: String, title: String, subtitle: String, isSelected: Bool)

class ModalPicker: UIViewController {

    @IBOutlet weak var pickerTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var onSelect: ((ModalPickerOption) -> Void)?
    var pickerTitle: String?
    var options: [ModalPickerOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        pickerTitleLabel.text = pickerTitle
        heightConstraint.constant = CGFloat(options.count) * tableView.rowHeight + 66 + (tableView.tableHeaderView?.bounds.height ?? 0)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissWithCustomAnimation()
    }
    
    private func dismissWithCustomAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
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
        
        cell.textLabel?.text = options[indexPath.row].title
        cell.detailTextLabel?.text = options[indexPath.row].subtitle
        
        return cell
        
    }
}

extension ModalPicker: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(options[indexPath.row])
        dismissWithCustomAnimation()
    }
}
