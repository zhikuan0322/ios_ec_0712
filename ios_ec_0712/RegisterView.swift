//
//  RegisterView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    @State var a = FormFieldViewModel(label: "帳號",placeholder: "請輸入帳號") { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        if !(value.contains("@") && value.contains(".")) {
            return "輸入值必須為電子信箱"
        }
        
        return nil
    }
    
    @State var name = FormFieldViewModel(label: "暱稱",placeholder: "請輸入暱稱") { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        return nil
    }
    
    @State var pw = FormFieldViewModel(label: "密碼",placeholder: "請輸入密碼", isSecure: true) { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        return nil
    }
    
    @State var isSeller = false
    
    @State var alertMsg = ""
    @State var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("註冊頁面")
                    .font(.largeTitle)
                
                FormFieldView(model: a)
                FormFieldView(model: name)
                FormFieldView(model: pw)
                
                Toggle(isOn: $isSeller) {
                    Text("是否為賣家")
                }
                
                Button {
                    let results = [a.validate(),name.validate(), pw.validate()]
                    
                    if (results.contains(false)) {
                        return;
                    }
                    
                    let current = users.first { user in
                        user.email == a.value
                    }
                    
                    if (current != nil) {
                        alertMsg = "帳號已存在"
                        showAlert.toggle()
                        return
                    }
    
                    let user = User(context: context)
                    user.id = UUID()
                    user.email = a.value
                    user.password = pw.value
                    user.name = name.value
                    user.is_seller = isSeller
                    
                    do {
                        try context.save()
                        alertMsg = "註冊成功"
                        showAlert.toggle()
                    } catch {
                        alertMsg = "註冊失敗"
                        showAlert.toggle()
                    }
                    
                    
                } label: {
                    Text("確認註冊")
                        .frame(width: 150, height: 30)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(20)
        }
        .navigationTitle("註冊")
        .navigationBarTitleDisplayMode(.inline)
        .alert("系統訊息", isPresented: $showAlert) {
            Button {
                if (alertMsg == "註冊成功")
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
