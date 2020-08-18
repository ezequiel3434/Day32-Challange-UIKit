//
//  ViewController.swift
//  Day32-Challange-UIKit
//
//  Created by Ezequiel Parada Beltran on 17/08/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let key = "list"
    let defaults = UserDefaults.standard
    var shoppingList = [String]()
    var shareBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let value = UserDefaults.standard.array(forKey: key) as? [String] {
            shoppingList = value
            print(shoppingList)
            tableView.reloadData()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearList))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        title = "Shopping List"
        
         let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        toolbarItems = [spacer, shareBtn]
        navigationController?.isToolbarHidden = false
    }
    
    // Clear list
    
    @objc func clearList() {
        shoppingList.removeAll(keepingCapacity: true)
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        tableView.reloadData()
    }
    @objc func addItem(){
        let ac = UIAlertController(title: "Enter a item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {
                return
            }
            self?.submit(answer)
            
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func submit(_ answer: String) {
        let loweAnswer = answer.lowercased()
        shoppingList.insert(loweAnswer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        defaults.set(shoppingList, forKey: key)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func shareTapped() {
        
        guard let list = shoppingList.joined(separator: "\n") as? String else
        {
            print("No image found")
            return
        }
       
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    


}

