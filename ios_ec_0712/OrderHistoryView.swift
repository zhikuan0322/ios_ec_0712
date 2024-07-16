//
//  OrderHistoryView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct OrderHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @AppStorage("user_id") var userId: String?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    var body: some View {
        let current = users.first { a in
            a.id?.uuidString == userId
        }
        ScrollView {
            if (current!.is_seller) {
                ForEach(current!.seller_order?.allObjects as! [Order]) { order in
                    OrderHistoryCard(order: order, isSeller: true)
                }
            } else {
                ForEach(current!.buyer_order?.allObjects as! [Order]) { order in
                    OrderHistoryCard(order: order, isSeller: false)
                }
            }
        }
        .padding(20)
        .navigationTitle("訂單記錄")
    }
}

struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
    }
}

struct OrderHistoryCard: View {
    @Environment(\.managedObjectContext) var context
    
    let order: Order
    let isSeller: Bool
    @State var showAlert = false
    
    init (order: Order, isSeller: Bool) {
        self.order = order
        self.isSeller = isSeller
    }
    
    var body: some View {
        let details = order.order_details?.allObjects as! [OrderDetail]
        VStack (alignment: .leading) {
            if (isSeller) {
                Text("買家: \(order.buyer!.name!)")
            } else {
                Text("賣家: \(order.seller!.name!)")
            }
            ForEach(details, id: \.self) { detail in
                HStack {
                    if (detail.product!.product_medias!.count > 0) {
                        Image(uiImage: UIImage(data:  (detail.product!.product_medias!.allObjects as! [ProductMedia]).first!.data!)!)
                            .resizable()
                            .frame(width: 192, height: 192)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image("Changli")
                            .resizable()
                            .frame(width: 192, height: 192)
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("\(detail.product!.name ?? "")")
                        Text("$ \(detail.product!.price)")
                        Text("數量: \(detail.quantity)")
                    }
                }
            }
            
            HStack {
                Spacer()
                
                VStack (alignment: .trailing) {
                    if (isSeller && !order.is_checked) {
                        Button {
                            order.is_checked = true
                            try! context.save()
                            showAlert.toggle()
                        } label: {
                            Text("確認訂單")
                        }
                        .buttonStyle(.borderedProminent)

                    }
                    
                    Text("訂單狀態: \(!order.is_checked ? "待確認" : "已確認")")
                    Text("總價: $ \(order.price)")
                }
            }
        }
        .padding(8)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black, lineWidth: 2)
        }
        .alert("系統訊息", isPresented: $showAlert) {
        
        } message: {
            Text("確認訂單成功")
        }

    }
}
