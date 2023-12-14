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
    var nameButton = UIButton(type: .system)
    var dateButton = UIButton(type: .system)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupConstraints()
        fetchFavoriteData()
        setupScreenTypeLabel()
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
    
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(screenTypeLabel)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        screenTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            screenTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenTypeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTypeLabel.heightAnchor.constraint(equalToConstant: 70),
            
            tableView.topAnchor.constraint(equalTo: screenTypeLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
