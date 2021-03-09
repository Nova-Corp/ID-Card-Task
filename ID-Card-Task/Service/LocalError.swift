//
//  LocalError.swift
//  TTLoginTask
//
//  Created by ADMIN on 21/02/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit

enum ValidationError: LocalizedError {
    case usernameMustBeEnter
    case passwordMustBeEnter
    case usernameAndPassword
    case zipCodeMustBeEnter
    case zipCodeMustBeNumeric
    case streetNameMustBeEnter
    case stateTooShort
    case emailMustBeEnter
    case emailNotValid
    case nameMustBeEnter
    case profileImageMustBeChoosen
    case dobMustBeEnter

    var errorDescription: String? {
        switch self {
        case .usernameMustBeEnter:
            return "Username is admin"
        case .passwordMustBeEnter:
            return "Password is 1234"
        case .usernameAndPassword:
            return "Dummy username is admin and password is 1234"
        case .zipCodeMustBeEnter:
            return "Zip code must be enter."
        case .zipCodeMustBeNumeric:
            return "Zip code must be a number."
        case .streetNameMustBeEnter:
            return "State must be enter."
        case .stateTooShort:
            return "State is too short."
        case .emailMustBeEnter:
            return "Please enter the email."
        case .emailNotValid:
            return "Please enter the valid email."
        case .nameMustBeEnter:
            return "Please enter the name name."
        case .profileImageMustBeChoosen:
            return "Please choose profile image."
        case .dobMustBeEnter:
            return "DOB Must be enter."
        }
    }
}
