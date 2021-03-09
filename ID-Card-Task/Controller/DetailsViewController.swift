//
//  DetailsViewController.swift
//  ID-Card-Task
//
//  Created by ADMIN on 08/03/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    var userDetails = [UserDetails]()
    
    let managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        let managedContext = appDelegate?.persistentContainer.viewContext

        return managedContext!
    }()
    
    
    fileprivate func fetchUserDetailsFromCoreData() {
        let fetchRequest: NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            userDetails = result
            userDetailsTableView.reloadData()
            
        } catch let err {
            print(err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        userDetailsTableView.delegate = self
        userDetailsTableView.dataSource = self
        
        let userDetailsTableViewCellNib = UINib(nibName: UserDetailsTableViewCell.identifier, bundle: nil)
        userDetailsTableView.register(userDetailsTableViewCellNib, forCellReuseIdentifier: UserDetailsTableViewCell.identifier)
        
        let idCardContainerTableViewCellNib = UINib(nibName: IDCardContainerTableViewCell.identifier, bundle: nil)
        userDetailsTableView.register(idCardContainerTableViewCellNib, forCellReuseIdentifier: IDCardContainerTableViewCell.identifier)
        
        
        fetchUserDetailsFromCoreData()
    }
}
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userDetails.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsTableViewCell.identifier) as! UserDetailsTableViewCell
            cell.configureUserDetails(user: userDetails[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: IDCardContainerTableViewCell.identifier) as! IDCardContainerTableViewCell
            cell.fetchUserDetailsFromCoreData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let isIdCard = userDetails[indexPath.row].value(forKey: "idCard") as! Bool
            if !isIdCard {
                let email = userDetails[indexPath.row].value(forKey: "email") as! String
                
                generateIdCardAlert(email: email)
                
                
            }
        }
    }
    
    func generateIdCardAlert(email: String) {
        let alert = UIAlertController(title: "Generate ID Card Now?", message: nil, preferredStyle: .alert)

        let cameraAction = UIAlertAction(title: "Yes", style: .default) { _ in
            
            let predicate = NSPredicate(format: "email = %@", email)
            let fetchRequest: NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let result = try self.managedContext.fetch(fetchRequest)
                let userDetails = result[0] as UserDetails
                
                userDetails.idCard = true
                try self.managedContext.save()

                self.fetchUserDetailsFromCoreData()
            } catch let err {
                print(err)
            }
        }

        let dismissAction = UIAlertAction(title: "No", style: .destructive)

        alert.addAction(cameraAction)
        alert.addAction(dismissAction)

        // MARK: - Fix constraint warning.

        alert.pruneNegativeWidthConstraints()

        present(alert, animated: true)
    }
}
