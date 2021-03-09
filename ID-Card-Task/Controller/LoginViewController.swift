//
//  ViewController.swift
//  ID-Card-Task
//
//  Created by ADMIN on 08/03/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!

    let credential: Set<AdminUser> = [
        AdminUser(username: "admin", password: "1234"),
        AdminUser(username: "admin1", password: "1234"),
    ]

    let inputValidationService = InputValidationService()

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        do {
            let username = try inputValidationService.validateUsername(usernameField.text)
            let password = try inputValidationService.validatePassword(passwordField.text)

            let validUser = credential.contains { $0.username == username && $0.password == password }

            if validUser {
                let adminUser = AdminUser(username: username, password: password)

                storeTheCredential(adminUserModel: adminUser)

                let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                let navigationController = UINavigationController(rootViewController: homeViewController)
                navigationController.navigationBar.topItem?.title = "Home"

                if let sceneDelegate = self.view.window!.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = navigationController
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = navigationController
                }

            } else {
                throw ValidationError.usernameAndPassword
            }

        } catch let err {
            self.present(err)
        }
    }

    fileprivate func storeTheCredential(adminUserModel: AdminUser) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(adminUserModel.username, forKey: "username")
    }
}
