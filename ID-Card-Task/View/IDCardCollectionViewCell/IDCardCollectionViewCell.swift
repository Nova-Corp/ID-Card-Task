//
//  IDCardCollectionViewCell.swift
//  ID-Card-Task
//
//  Created by ADMIN on 09/03/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit

class IDCardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "IDCardCollectionViewCell"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var barCodeImageView: UIImageView!
    
    func configureIdCard(user: UserDetails) {

        let fileName = user.value(forKey: "image") as! String
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let imageData = NSData(contentsOf: fileURL)
        
        profileImageView.image = UIImage(data: (imageData as Data?)!)
        userName.text = user.value(forKey: "name") as? String
        barCodeImageView.image = UIImage.init(barcode: user.value(forKey: "name") as! String)
    }
    
}
