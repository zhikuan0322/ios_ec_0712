//
//  SellerProductView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct SellerProductView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    @AppStorage("user_id") var userId: String?
    var body: some View {
        ScrollView {
            let current = users.first { a in
                a.id?.uuidString == userId
            }
            
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 175))]) {
                    ForEach(current?.products?.allObjects as! [Product], id: \.self) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            VStack (alignment: .leading) {
                                if (product.product_medias!.count > 0) {
                                    Image(uiImage: UIImage(data:  (product.product_medias!.allObjects as! [ProductMedia]).first!.data!)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit  )
                                } else {
                                    Image("Changli")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                
                                Text(product.name ?? "")
                                Text("$ \(product.price)")
                            }
                            .padding(8)
                            .frame(width: 175, height: 200)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                        .stroke(.black, lineWidth: 2)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("我的賣場")
        .toolbar {
            NavigationLink {
                AddProductView()
            } label: {
                Text("新增商品")
            }
        }
    }
}

struct SellerProductView_Previews: PreviewProvider {
    static var previews: some View {
        SellerProductView()
    }
}
