//
//  UserDetailsTableViewCell.swift
//  ID-Card-Task
//
//  Created by ADMIN on 08/03/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit
import CoreData

class UserDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var idCardLabel: UILabel!
    
    static let identifier = "UserDetailsTableViewCell"
    
    func configureUserDetails(user: UserDetails) {
        nameLabel.text = user.value(forKey: "name") as? String
        emailLabel.text = user.value(forKey: "email") as? String
        streetLabel.text = user.value(forKey: "street") as? String
        pinLabel.text = user.value(forKey: "zipCode") as? String
        
        let isIdCard = user.value(forKey: "idCard") as! Bool
        idCardLabel.text = isIdCard ? "Yes" : "No"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        dobLabel.text = dateFormatter.string(from: user.value(forKey: "dateOfBirth") as! Date)
    }
}
