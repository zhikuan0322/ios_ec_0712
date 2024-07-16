//
//  ProductPage.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct ProductView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Product.id, ascending: true)], animation: .default)
    var products: FetchedResults<Product>
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 175))]) {
                    ForEach(products, id: \.self) { product in
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
        .navigationTitle("產品列表")
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
