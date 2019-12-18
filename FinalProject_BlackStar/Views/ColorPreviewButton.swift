//
//  ColorPreviewButton.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 01.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPreviewButton: UIButton {

    @IBOutlet weak var colorNameLabel: UILabel!
    @IBOutlet weak var roundedStrokeView: RoundedView!
    @IBOutlet weak var colorView: RoundedImageView!
    @IBOutlet weak var disclosureIndicator: UIImageView!
    
    let nibName = "ColorPreviewButton"
    
    var view: UIView!
    
    var colorURL: String? {
        didSet {
            if let colorURL = colorURL {
                
                ImageProvider.loadImage(url: colorURL) { image in
                    
                    if let image = image {
                        
                        self.colorView.image = image
                        
                        self.roundedStrokeView.isHidden = false
                        self.colorView.isHidden = false
                    
                        
                    } else {
                        self.roundedStrokeView.isHidden = true
                        self.colorView.isHidden = true
                    }
                    
                }
                
            } else {
                roundedStrokeView.isHidden = true
                colorView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)

        // 3. Setup view from .xib file
        xibSetup()
    } 
    
    func xibSetup() {
        view = loadViewFromNib()

        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        view.addGestureRecognizer(tap)
    }

    @objc func tap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            sendActions(for: .touchUpInside)
        }
    }
    
    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

}

class RoundedView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
    }
    
}

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
    }
}
