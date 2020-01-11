//
//  ConfirmationViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 05.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {

    private var boxView: UIView! = UIView()
    private var titleLabel: UILabel! = UILabel()
    private var buttonsStackView: UIStackView! = UIStackView()
    private var buttonsContainerView: UIView! = UIView()
    
    private var buttonHeight: CGFloat = 60.0
    
    private var actions: [ConfirmationAction] = []
    private var buttons: [UIButton] = []

    var color: UIColor?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        setupBoxView()
        setupTitleLabel()
        setupButtonsContainer()
        
    }
    
    func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    func addAction(_ action: ConfirmationAction) {
        actions.append(action)
        
        let button = UIButton(type: .roundedRect)
        button.setTitle(action.title, for: .normal)
        
        switch action.style {
        case .ok:
            
            button.backgroundColor = color ?? .systemBlue
            button.tintColor = .white
            
        case .cancel:
            
            button.backgroundColor = .clear
            button.tintColor = color ?? .systemBlue
            
        }
        
        button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.layer.cornerRadius = 5.0
        buttons.append(button)
        buttonsStackView.addArrangedSubview(button)
        
    }
    
    private func setupBoxView() {
        boxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boxView)
        
        boxView.backgroundColor = .white
        boxView.layer.cornerRadius = 5.0

        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            boxView.widthAnchor .constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            boxView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20.0, weight: .regular)
        boxView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            boxView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            boxView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            boxView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            titleLabel.heightAnchor.constraint(equalTo: boxView.heightAnchor, multiplier: 0.2)
        ])
        
    }
    
    private func setupButtonsContainer() {
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        boxView.addSubview(buttonsContainerView)
        
        NSLayoutConstraint.activate([
            buttonsContainerView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10.0),
            buttonsContainerView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10.0),
            buttonsContainerView.heightAnchor.constraint(equalTo: boxView.heightAnchor, multiplier: 0.8),
            buttonsContainerView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor)
        ])
        
        
        buttonsContainerView.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.alignment = .fill
        buttonsStackView.axis = .vertical
        buttonsStackView.distribution = .fill
        buttonsStackView.spacing = 10.0
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: buttonsContainerView.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc func buttonPressed(_ sender: UIButton) {
        
        let index = buttons.firstIndex(of: sender)!
        let action = actions[index]
        
        action.handler?(action)
        
        dismiss(animated: true, completion: nil)
    }
    
}

class ConfirmationAction {
    var title: String?
    var style: ConfirmationStyle
    var handler:((ConfirmationAction) -> Void)?
    
    init(title: String?, style: ConfirmationStyle, handler: ((ConfirmationAction) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

enum ConfirmationStyle {
    case ok
    case cancel
}
