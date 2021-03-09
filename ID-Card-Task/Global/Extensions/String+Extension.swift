//
//  String+Extension.swift
//  ID-Card-Task
//
//  Created by ADMIN on 08/03/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
