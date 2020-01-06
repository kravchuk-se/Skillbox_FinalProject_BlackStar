//
//  LoadingViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 05.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {

    private var boxView: UIView!
    private var activitiIndicator: NVActivityIndicatorView!
    private var successMessageLabel: UILabel!
    
    private var boxViewWidthConstraint: NSLayoutConstraint!
    private var boxViewHeightConstraint: NSLayoutConstraint!
    
    var successMessage: String?
    
    private var taskCompleted = false {
        didSet {
            if taskCompleted {
                activitiIndicator.stopAnimating()
                
                if successMessage != nil {
                
                successMessageLabel.alpha = 0
                successMessageLabel.isHidden = false
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.boxViewWidthConstraint.constant = self.view.bounds.width - (20.0 * 2.0)
                    
                    self.view.layoutIfNeeded()
                    
                }, completion: { _ in
                
                    UIView.animate(withDuration: 0.2, animations: {
                        self.successMessageLabel.alpha = 1
                        
                        self.boxViewHeightConstraint.constant = self.successMessageLabel.intrinsicContentSize.height + (20.0 * 2)
                        
                    })
                    
                })
                
                } else {
                    dismiss(animated: true, completion: nil)
                }
                    
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxView = UIView()
        successMessageLabel = UILabel()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        boxView.layer.cornerRadius = 5.0
        boxView.backgroundColor = .white
        boxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boxView)
        
        boxViewWidthConstraint = boxView.widthAnchor.constraint(equalToConstant: 80.0)
        boxViewHeightConstraint = boxView.heightAnchor.constraint(equalToConstant: 80.0)
        
        NSLayoutConstraint.activate([
            boxViewWidthConstraint,
            boxViewHeightConstraint,
            view.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: boxView.centerYAnchor)
        ])
        
        
        activitiIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: .circleStrokeSpin, color: .black, padding: 10.0)
        
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        boxView.addSubview(activitiIndicator)
        
        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: activitiIndicator.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: activitiIndicator.centerYAnchor)
        ])
        
        successMessageLabel.isHidden = true
        successMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        successMessageLabel.text = successMessage
        successMessageLabel.numberOfLines = 0
        successMessageLabel.textAlignment = .center
        
        boxView.addSubview(successMessageLabel)
        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: successMessageLabel.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: successMessageLabel.centerYAnchor),
            boxView.widthAnchor.constraint(equalTo: successMessageLabel.widthAnchor, multiplier: 1, constant: 20)
        ])
        
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { [weak self] _ in
            self?.taskCompleted = true
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        activitiIndicator.startAnimating()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
}
