//
//  LoadingViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 05.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    private var boxView: UIView!
    private var activitiIndicator: UIActivityIndicatorView!
    
    private var taskCompleted = false {
        didSet {
            if taskCompleted {
                activitiIndicator.stopAnimating()
                dismiss(animated: true, completion: nil)
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
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        boxView.layer.cornerRadius = 5.0
        boxView.backgroundColor = .white
        boxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boxView)
        NSLayoutConstraint.activate([
            boxView.widthAnchor.constraint(equalToConstant: 80.0),
            boxView.heightAnchor.constraint(equalToConstant: 80.0),
            view.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: boxView.centerYAnchor)
        ])
        
        
        activitiIndicator = UIActivityIndicatorView(style: .large)
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        boxView.addSubview(activitiIndicator)
        
        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: activitiIndicator.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: activitiIndicator.centerYAnchor)
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
