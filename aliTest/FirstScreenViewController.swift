//
//  FirstScreen.swift
//  aliTest
//
//  Created by Rita on 22.11.2023.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    lazy var stackView = UIStackView(arrangedSubviews: [titleName,
                                                        triviaButton,
                                                        mathButton,
                                                        dateButton,
                                                        yearButton,
                                                        favoriteButton])
    let titleName = UILabel()
    let triviaButton = UIButton(type: .system)
    let mathButton = UIButton(type: .system)
    let dateButton = UIButton(type: .system)
    let yearButton = UIButton(type: .system)
    let favoriteButton = UIButton(type: .system)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupButtons()
        configureStackView()
        setupLabel()
    }
    
    func setupButtons() {
        let buttons = [triviaButton, mathButton, dateButton, yearButton, favoriteButton]
        buttons.forEach {
            $0.layer.cornerRadius = 10
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            $0.tintColor = UIColor.white
            $0.backgroundColor = .darkGray
        }
        triviaButton.setTitle("Trivia", for: .normal)
        mathButton.setTitle("Math", for: .normal)
        dateButton.setTitle("Date", for: .normal)
        yearButton.setTitle("Year", for: .normal)
        favoriteButton.setTitle("Favorite", for: .normal)
        
        triviaButton.addTarget(self, action: #selector(triviaButtonTapped), for: .touchUpInside)
        mathButton.addTarget(self, action: #selector(mathButtonTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
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
    
    @objc func triviaButtonTapped() {
        let vc = TypesScreenViewController()
        vc.screenType = .trivia
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func mathButtonTapped() {
        let vc = TypesScreenViewController()
        vc.screenType = .math
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dateButtonTapped() {
        let vc = TypesScreenViewController()
        vc.screenType = .date
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func yearButtonTapped() {
        let vc = TypesScreenViewController()
        vc.screenType = .year
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func favoriteButtonTapped() {
        let vc = FavoriteScreenViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

