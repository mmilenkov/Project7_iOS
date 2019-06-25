//
//  ViewController.swift
//  Project7
//
//  Created by Miloslav G. Milenkov on 24/06/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    
    var filtered = [Petition]()
    var isFiltered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showFilter))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltered) {
            return filtered.count
        }
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition: Petition
        if(isFiltered) {
            petition = filtered[indexPath.row]
        } else {
            petition = petitions[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. Please try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated:true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data is supplied by We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated:true)
    }
    
    @objc func showFilter() {
        let ac = UIAlertController(title: "Filter by title", message: "Please enter the word you want to filter by", preferredStyle: .alert)
        
        ac.addTextField()
        let action = UIAlertAction(title: "Filter by Title", style: .default) {
            [weak self, weak ac] action in
            guard let word = ac?.textFields?[0].text else { return }
            self?.filter(word: word)
        }
        ac.addAction(action)
        present(ac, animated:true)
    }
    
    func filter(word: String) {
        filtered.removeAll()
        isFiltered = true
        
        for petition in petitions {
            if(petition.title.lowercased().contains(word.lowercased())) {
                filtered.append(petition)
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFiltered == true {
            isFiltered = false
            tableView.reloadData()
        }
    }
}

