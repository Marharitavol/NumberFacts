//
//  FirstScreen.swift
//  aliTest
//
//  Created by Rita on 22.11.2023.
//

import UIKit

class FirstScreen: UIViewController {
    
    lazy var stackView = UIStackView(arrangedSubviews: [titleName,triviaButton, mathButton, dateButton, yearButton])
    let titleName = UILabel()
    let triviaButton = UIButton(type: .system)
    let mathButton = UIButton(type: .system)
    let dateButton = UIButton(type: .system)
    let yearButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupButtons()
        configureStackView()
        setupLabel()
    }
    
    func setupButtons() {
        let buttons = [triviaButton, mathButton, dateButton, yearButton]
        buttons.forEach {
            $0.layer.cornerRadius = 10
            $0.setTitle("Done", for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            $0.tintColor = UIColor.white
            $0.backgroundColor = .darkGray
        }
        triviaButton.setTitle("Trivia", for: .normal)
        mathButton.setTitle("Math", for: .normal)
        dateButton.setTitle("Date", for: .normal)
        yearButton.setTitle("Year", for: .normal)
    }
    
    func setupLabel() {
        titleName.text = "Number Facts"
        titleName.font = titleName.font.withSize(56)
        titleName.textAlignment = .center

    }
    
    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        setupStackViewConstraints()
    }
    
    func setupStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
    }
    
    
}

