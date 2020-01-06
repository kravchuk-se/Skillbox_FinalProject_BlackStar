//
//  TagView.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 30.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

// @IBDesignable
class TagView: UIView {

    let boxView: UIView = UIView()
    let tagLabel: UILabel = UILabel()

    var isSetuped = false
    @IBInspectable var tagColor: UIColor? = .systemRed {
        didSet {
            boxView.backgroundColor = tagColor
        }
    }
    
    @IBInspectable var vPadding: CGFloat = 0.0
    @IBInspectable var hPadding: CGFloat = 0.0
    
    @IBInspectable var tagText: String? = "-30%" {
        didSet {
            tagLabel.text = tagText
        }
    }
    
    override func layoutSubviews() {
        
        if !isSetuped {
            isSetuped = true
            initialSetup()
        }
        
        boxView.layer.cornerRadius = 2.0
    }
    
    func initialSetup() {
        
        tagLabel.textAlignment = .center
        tagLabel.baselineAdjustment = .alignCenters
        tagLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        tagLabel.textColor = .white
        tagLabel.adjustsFontSizeToFitWidth = true
        tagLabel.minimumScaleFactor = 0.1
        
        addSubview(boxView)
        boxView.addSubview(tagLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        boxView.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints([
            leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: -hPadding),
            trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: hPadding),
            topAnchor.constraint(equalTo: boxView.topAnchor, constant: -vPadding),
            bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: vPadding)
        ])
        
        boxView.addConstraints([
            boxView.centerXAnchor.constraint(equalTo: tagLabel.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
            boxView.leadingAnchor.constraint(greaterThanOrEqualTo: tagLabel.leadingAnchor, constant: -3.0),
            boxView.trailingAnchor.constraint(greaterThanOrEqualTo: tagLabel.trailingAnchor, constant: +3.0)
        ])
        
    }
    
}
