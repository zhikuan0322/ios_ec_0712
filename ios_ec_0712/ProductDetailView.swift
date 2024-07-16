//
//  ProductDetailView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct ProductDetailView: View {
    @AppStorage("user_id") var userId: String?
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    @State var alertMessage = ""
    @State var isAlert = false
    
    let product: Product
    
    init (product: Product) {
        self.product = product
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                TabView {
                    if (product.product_medias!.count > 0) {
                        ForEach(product.product_medias?.allObjects as! [ProductMedia], id: \.self) { media in
                            Image(uiImage: UIImage(data: media.data!)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    } else {
                        Image("Changli")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .frame(height: 300)
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                VStack (alignment: .leading) {
                    HStack {
                        Text(product.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("$ \(product.price)")
                            .foregroundColor(.accentColor)
                    }
                    .padding(.vertical, 8)
                    
                    Text(product.summary ?? "")
                }
                .padding(16)
            }
        }
        .navigationTitle(product.name ?? "產品詳細資訊")
        .navigationBarTitleDisplayMode(.inline  )
        .toolbar {
            ToolbarItem {
                Button {
                    if (userId == nil) {
                        alertMessage = "登入以使用此功能"
                        isAlert = true
                        return
                    }
                    
                    let current = users.first { User in
                        User.id!.uuidString == userId!
                    }
                    
                    if (current!.is_seller) {
                        alertMessage = "僅有買家可使用此功能"
                        isAlert = true
                        return
                    }
                    
                    let duplicate = (current?.shopping_car?.allObjects as! [ShoppingCar])
                        .first { car in
                            car.product?.id == product.id
                        }
                    
                    if (duplicate != nil) {
                        duplicate?.quantity += 1
                    } else {
                        let shoppingCar = ShoppingCar(context: context)
                        shoppingCar.id = UUID()
                        shoppingCar.buyer = current
                        shoppingCar.quantity = 1
                        shoppingCar.product = product
                    }
                    
                    do {
                        try context.save()
                        
                        alertMessage = "加入購物車成功"
                        isAlert = true
                    } catch {
                        alertMessage = "加入購物車失敗"
                        isAlert = true
                    }
                    
                    
                } label: {
                    Text("新增至購物車")
                }
            }
        }
        .alert("系統訊息", isPresented: $isAlert) {
            
        } message: {
            Text(alertMessage)
        }

    }
}
