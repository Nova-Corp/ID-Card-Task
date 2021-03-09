//
//  HomeViewController.swift
//  ID-Card-Task
//
//  Created by ADMIN on 08/03/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import CoreData
import Photos
import UIKit

class HomeViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var userImageView: UIImageView!

    @IBOutlet var dobTextField: UITextField!

    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()

    @IBOutlet var userNameField: UITextField!
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var userStreetField: UITextField!
    @IBOutlet var userZipCodeField: UITextField!

    let inputValidationService = InputValidationService()

    let managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        let managedContext = appDelegate?.persistentContainer.viewContext

        return managedContext!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        dobTextField.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapUserImageView))
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dobTextField {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()

            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTapDoneButtonForDatePicker))

            toolBar.setItems([doneButton], animated: true)

            dobTextField.inputAccessoryView = toolBar

            dobTextField.inputView = datePicker
        }
    }

    @objc func didTapDoneButtonForDatePicker() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        dobTextField.text = dateFormatter.string(from: datePicker.date)

        view.endEditing(true)
    }

    @IBAction func saveButton(_ sender: UIButton) {
        do {
            guard let profileImage = userImageView.image else { throw ValidationError.profileImageMustBeChoosen }
            let name = try inputValidationService.validateName(userNameField.text)
            let email = try inputValidationService.validateEmail(userEmailField.text)
            _ = try inputValidationService.validateDob(dobTextField.text)
            let street = try inputValidationService.validateStreetName(userStreetField.text)
            let zipCode = try inputValidationService.validateZipCode(userZipCodeField.text)

            let imageName = "\(UUID().uuidString).jpg"

            let userDetails = UserDetails(context: managedContext)

            userDetails.image = imageName
            userDetails.name = name
            userDetails.email = email
            userDetails.dateOfBirth = datePicker.date
            userDetails.street = street
            userDetails.zipCode = zipCode
            userDetails.idCard = false

            saveImageToDocumentDirectory(image: profileImage, fileName: imageName)

            managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            try managedContext.save()

            clearData()
            
            self.presentAlert(with: "Successfully saved.")

        } catch let err {
            self.present(err)
           
        }
    }

    func clearData() {
        view.endEditing(true)
        userImageView.image = nil
        [
            userNameField,
            dobTextField,
            userEmailField,
            userStreetField,
            userZipCodeField,

        ].forEach { $0?.text = nil }
    }

    private func saveImageToDocumentDirectory(image: UIImage, fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
            } catch let err {
                self.present(err)
            }
        }
    }

    @IBAction func clearButton(_ sender: UIButton) {
        clearData()
    }

    @objc func didTapLogoutButton() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "username")

        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.title = "Login"

        if let sceneDelegate = self.view.window!.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navigationController
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navigationController
        }
    }

    fileprivate func configureNavigationBar() {
        let viewUsers = UIBarButtonItem(title: "View", style: .plain, target: self, action: #selector(didTapViewButton))
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogoutButton))

        navigationItem.rightBarButtonItem = viewUsers
        navigationItem.leftBarButtonItem = logout
    }
    
    @objc func didTapViewButton() {
        let detailsViewController = storyboard?.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func didTapUserImageView() {
        let alert = UIAlertController(title: "Choose Image", message: "From where you want to pick this image?", preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.getImage(fromSourceType: .camera)
        }
        let albumAction = UIAlertAction(title: "Photo Album", style: .default) { _ in
            self.getImage(fromSourceType: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(cameraAction)
        alert.addAction(albumAction)
        alert.addAction(dismissAction)

        // MARK: - Fix constraint warning.

        alert.pruneNegativeWidthConstraints()

        present(alert, animated: true)
    }

    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        // Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerViewDelegate.

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true) { [weak self] in

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

            self?.userImageView.image = image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
