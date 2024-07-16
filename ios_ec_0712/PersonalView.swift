//
//  PersonalView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct PersonalView: View {
    @AppStorage("user_id") var userId: String?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    @State var showAlert = false
    @State var alertMsg = ""
    
    var body: some View {
        if (userId == nil) {
            VStack {
                Text("登入以查看更多資訊")
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("登入")
                    }
                }
            }
            .navigationTitle("個人資訊")
            .navigationBarTitleDisplayMode(.inline)
        } else {
            let current = users.first { User in
                User.id!.uuidString == userId!
            }!
            
            ScrollView {
                VStack (alignment: .leading) {
                    VStack (alignment: .leading)  {
                        Text("暱稱: \(current.name!)")
                        Text("Email: \(current.email!)")
                        Text("使用者類別: \(current.is_seller ? "賣家" : "買家")")
                    }
                    
                    if (current.is_seller) {
                        NavigationLink {
                            SellerProductView()
                        } label: {
                            Label("我的賣場", systemImage: "cart.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        NavigationLink {
                            ShoppingCarView()
                        } label: {
                            Label("購物車", systemImage: "cart.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    NavigationLink {
                        OrderHistoryView()
                    } label: {
                        Text("訂單記錄")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        UserDefaults.standard.setValue(nil, forKey: "user_id")
                        alertMsg = "登出成功"
                        showAlert.toggle()
                    } label: {
                        Text("登出")
                    }
                    .buttonStyle(.borderedProminent)

                }
                .padding(20)
            }
            .navigationTitle("個人資訊")
            .alert("系統訊息", isPresented: $showAlert) {
                
            } message: {
                Text(alertMsg)
            }

        }
    }
}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView()
    }
}
