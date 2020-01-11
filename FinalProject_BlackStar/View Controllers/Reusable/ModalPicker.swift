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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var onSelect: ((ModalPickerOption) -> Void)?
    var pickerTitle: String?
    var options: [ModalPickerOption] = []
    
    // MARK: - View controller Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let tableHeight = CGFloat(options.count) * tableView.rowHeight + 66 + (tableView.tableHeaderView?.bounds.height ?? 0)
        
        pickerTitleLabel.text = pickerTitle
        heightConstraint.constant = tableHeight
        bottomConstraint.constant = -tableHeight
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.1) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.bottomConstraint.constant = -self.heightConstraint.constant
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Handle touches
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
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
    }
}
