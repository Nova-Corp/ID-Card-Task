//
//  InputValidationService.swift
//  TTLoginTask
//
//  Created by ADMIN on 21/02/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit

struct InputValidationService {
    func validateUsername(_ username: String?) throws -> String {
        guard let number = username else { throw ValidationError.usernameMustBeEnter }
        guard username?.count != 0 else { throw ValidationError.usernameMustBeEnter }
        return String(number)
    }
    
    func validatePassword(_ password: String?) throws -> String {
        guard let number = password else { throw ValidationError.passwordMustBeEnter }
        guard password?.count != 0 else { throw ValidationError.passwordMustBeEnter }
        return String(number)
    }
    
    func validateZipCode(_ zipCode: String?) throws -> String {
        guard let zipCode = Int(zipCode!) else { throw ValidationError.zipCodeMustBeNumeric }
        guard zipCode > 9999 else { throw ValidationError.zipCodeMustBeEnter }
        return String(zipCode)
    }
    
    func validateStreetName(_ street: String?) throws -> String {
        guard let state = street else { throw ValidationError.streetNameMustBeEnter }
        guard state.count != 0 else { throw ValidationError.streetNameMustBeEnter }
        return state
    }
    
    func validateEmail(_ email: String?) throws -> String {
        guard let email = email else { throw ValidationError.emailMustBeEnter }
        guard email.count != 0 else { throw ValidationError.emailMustBeEnter }
        guard email.isValidEmail() else { throw ValidationError.emailNotValid }
        return email
    }
    
    func validateName(_ name: String?) throws -> String {
        guard let name = name else { throw ValidationError.nameMustBeEnter }
        guard name.count != 0 else { throw ValidationError.nameMustBeEnter }
        return name
    }
    
    func validateDob(_ dob: String?) throws -> String {
        guard let name = dob else { throw ValidationError.dobMustBeEnter }
        guard name.count != 0 else { throw ValidationError.dobMustBeEnter }
        return name
    }
}
