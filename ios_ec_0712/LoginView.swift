//
//  LoginView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    let account = FormFieldViewModel(label: "帳號",placeholder: "請輸入帳號") { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        return nil
    }
    
    let pw = FormFieldViewModel(label: "密碼",placeholder: "請輸入密碼", isSecure: true) { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        return nil
    }
    
    @State var alertMsg = ""
    @State var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("登入頁面")
                    .font(.largeTitle)
                
                FormFieldView(model: account)
                FormFieldView(model: pw)
                
                Button {
                    let results = [account.validate(), pw.validate()]
                    
                    if (results.contains(false)) {
                        return;
                    }
                    
                    let current = users.first { user in
                        user.email == account.value && pw.value == user.password
                    }
                    
                    if (current == nil) {
                        alertMsg = "帳號密碼錯誤"
                        showAlert.toggle()
                        return
                    }
                    
                    UserDefaults.standard.setValue(current!.id?.uuidString, forKey: "user_id")
                    alertMsg = "登入成功"
                    showAlert.toggle()
                    
                    
                } label: {
                    Text("登入")
                        .frame(width: 150, height: 30)
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink {
                    RegisterView()
                } label: {
                    Text("註冊")
                        .foregroundColor(.white)
                        .frame(width: 175, height: 50)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            }
            .padding(20)
        }
        .navigationTitle("登入")
        .navigationBarTitleDisplayMode(.inline)
        .alert("系統訊息", isPresented: $showAlert) {
            Button {
                if (alertMsg == "登入成功")
                {
                    dismiss()
                }
            } label: {
                Text("Ok")
            }

        } message: {
            Text(alertMsg)
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
