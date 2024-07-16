//
//  FormFieldViewModel.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

class FormFieldViewModel: ObservableObject {
    let label: String
    let placeholder: String
    let isSecure: Bool
    let isMultipleLine: Bool
    let validation: (String) -> String?
    
    @Published var value: String = ""
    @Published var errorMessage: String?
    
    init(label: String, placeholder: String = "", isSecure: Bool = false, isMultipleLine: Bool = false, validation: @escaping (String) -> String?) {
        self.label = label
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.isMultipleLine = isMultipleLine
        self.validation = validation
    }
    
    func validate() -> Bool {
        errorMessage = validation(value)
        return errorMessage == nil
    }
}
