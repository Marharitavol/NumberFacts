//
//  FavoriteScreenViewController.swift
//  aliTest
//
//  Created by Rita on 08.12.2023.
//

import UIKit
import CoreData

class FavoriteScreenViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var favorites: [Favorite]?
    var screenTypeLabel = UILabel()
    var sortNameButton = UIButton(type: .system)
    var sortDateButton = UIButton(type: .system)
    var sortLabel = UILabel()
    lazy var stackView = UIStackView(arrangedSubviews: [sortLabel, sortDateButton, sortNameButton, UIView()])
    
    var isNameButtonSortingReversed = true
    var isDateButtonSortingReversed = true

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupConstraints()
        fetchFavoriteData()
        setupScreenTypeLabel()
        setupStackViewElement()
        tableView.backgroundColor = .white
        view.backgroundColor = .secondarySystemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchFavoriteData() {
        do {
            let request = Favorite.fetchRequest()
            
            self.favorites = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    func setupScreenTypeLabel() {
        screenTypeLabel.text = "Favorite Facts"
        screenTypeLabel.backgroundColor = .opaqueSeparator
        screenTypeLabel.textAlignment = .center
        screenTypeLabel.font = screenTypeLabel.font.withSize(25)
    }
    
    func setupStackViewElement() {
        sortLabel.text = "Sort by:"
        sortLabel.font = sortLabel.font.withSize(15)
        
        sortNameButton.setTitle("Name", for: .normal)
        sortNameButton.tintColor = .black
        
        sortDateButton.setTitle("Date", for: .normal)
        sortDateButton.tintColor = .black
        
        stackView.axis = .horizontal
        stackView.spacing = 30
        
        sortNameButton.addTarget(self, action: #selector(sortNameButtonTapped), for: .touchUpInside)
        sortDateButton.addTarget(self, action: #selector(sortDateButtonTapped), for: .touchUpInside)
    }
    
    func imageButtonConfiguration(button: UIButton ,symbol: String) {
        button.setImage(UIImage(systemName: symbol, withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(screenTypeLabel)
        view.addSubview(stackView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        screenTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: screenTypeLabel.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            
            screenTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTypeLabel.heightAnchor.constraint(equalToConstant: 70),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func sortNameButtonTapped() {
        
        isDateButtonSortingReversed = true
        imageButtonConfiguration(button: sortDateButton, symbol: "")

        
        favorites?.sort { (favorite1, favorite2) in
            guard let facts1 = favorite1.favoritesFacts, let facts2 = favorite2.favoritesFacts else {
                return false
            }
            if isNameButtonSortingReversed {
                imageButtonConfiguration(button: sortNameButton, symbol: "chevron.up")
                return facts1.localizedStandardCompare(facts2) == .orderedAscending
            } else {
                imageButtonConfiguration(button: sortNameButton, symbol: "chevron.down")
                return facts1.localizedStandardCompare(facts2) == .orderedDescending
            }
        }
        
        isNameButtonSortingReversed.toggle()

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
    
    @objc func sortDateButtonTapped() {
        
        isNameButtonSortingReversed = true
        imageButtonConfiguration(button: sortNameButton, symbol: "")
        
        if isDateButtonSortingReversed {
            imageButtonConfiguration(button: sortDateButton, symbol: "chevron.up")
            favorites = favorites?.sorted(by: { $0.savingDate ?? Date() > $1.savingDate ?? Date() })
        } else {
            imageButtonConfiguration(button: sortDateButton, symbol: "chevron.down")
            favorites = favorites?.sorted(by: { $0.savingDate ?? Date() < $1.savingDate ?? Date() })
        }
        
        isDateButtonSortingReversed.toggle()

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
}

extension FavoriteScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let favorite = self.favorites![indexPath.row]
        cell.textLabel?.text = favorite.favoritesFacts
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            let favoriteToRemove = self.favorites![indexPath.row]
            self.context.delete(favoriteToRemove)
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchFavoriteData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
