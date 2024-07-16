//
//  FormFieldView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct FormFieldView: View {
    @ObservedObject var model: FormFieldViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(model.label)
                .fontWeight(.bold)
            
            if (model.isSecure) {
                SecureField(model.placeholder, text: $model.value)
                    .padding(8)
                    .frame(height: 40)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 1)
                    }
            } else if (model.isMultipleLine) {
                TextEditor(text: $model.value)
                    .padding(8)
                    .frame(height: 160)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 1)
                    }
            } else {
                TextField(model.placeholder, text: $model.value)
                    .padding(8)
                    .frame(height: 40)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 1)
                    }
            }
            
            if let msg = model.errorMessage {
                Text(msg)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .onAppear {
            model.value = ""
            model.errorMessage = ""
        }
    }
}
