//
//  IDCardContainerTableViewCell.swift
//  ID-Card-Task
//
//  Created by ADMIN on 09/03/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import CoreData
import UIKit

class IDCardContainerTableViewCell: UITableViewCell {
    static let identifier = "IDCardContainerTableViewCell"

    @IBOutlet var idCardCollectioView: UICollectionView!

    let managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        let managedContext = appDelegate?.persistentContainer.viewContext

        return managedContext!
    }()

    var userDetails = [UserDetails]()

    func fetchUserDetailsFromCoreData() {
        let predicate = NSPredicate(format: "idCard = %@", NSNumber(value: true))
        let fetchRequest: NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            userDetails = result
            idCardCollectioView.reloadData()
            
        } catch let err {
            print(err)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        idCardCollectioView.delegate = self
        idCardCollectioView.dataSource = self

        let idCardCollectionViewCellNib = UINib(nibName: IDCardCollectionViewCell.identifier, bundle: nil)
        idCardCollectioView.register(idCardCollectionViewCellNib, forCellWithReuseIdentifier: IDCardCollectionViewCell.identifier)

        fetchUserDetailsFromCoreData()
    }
}

extension IDCardContainerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userDetails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDCardCollectionViewCell.identifier, for: indexPath) as! IDCardCollectionViewCell
        cell.configureIdCard(user: userDetails[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 245, height: 300)
    }
}
