//
//  ShoppingCarVIew.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct ShoppingCarView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    @AppStorage("user_id") var userId: String?
    
    @State var total: Int = 0
    
    @State var showAlert = false
    @State var alertMsg = ""
    
    var body: some View {
        let current = users.first { a in
            a.id?.uuidString == userId
        }
        
        ScrollView {
            VStack {
                ForEach(current?.shopping_car?.allObjects as! [ShoppingCar]) { car in
                    ShoppingCarCard(shoppingCar: car) {
                        total = Int((current?.shopping_car?.allObjects as! [ShoppingCar])
                            .reduce(0, { partialResult, ShoppingCar in
                                partialResult + ShoppingCar.quantity * ShoppingCar.product!.price
                            }))
                    }
                }
                .onAppear {
                    total = Int((current?.shopping_car?.allObjects as! [ShoppingCar])
                        .reduce(0, { partialResult, ShoppingCar in
                            partialResult + ShoppingCar.quantity * ShoppingCar.product!.price
                        }))
                }
                
                HStack {
                    Spacer()
                    
                    Text("總額: $ \(total)")
                    
                    Button {
                        let cars = current?.shopping_car?.allObjects as! [ShoppingCar];
                        
                        if cars.count < 1 {
                            alertMsg = "請至少購買一樣商品"
                            showAlert.toggle()
                            return
                        }
                        
                        let sellers = cars.map { car in
                            car.product!.seller!.id
                        }
                        
                        if (Set(sellers).count > 1) {
                            alertMsg = "只可購買一個買家的商品"
                            showAlert.toggle()
                            return
                        }
                        
                        let order = Order(context: context)
                    
                        let details = cars.map { car in
                            let detail = OrderDetail(context: context)
                            detail.id = UUID()
                            detail.product = car.product
                            detail.quantity = car.quantity
                            context.delete(car)
                            
                            return detail
                        }
                        
                        order.id = UUID()
                        order.price = Int64(total)
                        order.seller = cars.first!.product!.seller
                        order.buyer = current
                        order.created_date = Date.now
                        order.is_checked = false
                        order.order_details = NSSet(array: details)
                        
                        try! context.save()
                        
                        alertMsg = "購買成功"
                        showAlert.toggle()
                        
                        total = Int((current?.shopping_car?.allObjects as! [ShoppingCar])
                            .reduce(0, { partialResult, ShoppingCar in
                                partialResult + ShoppingCar.quantity * ShoppingCar.product!.price
                            }))
                     } label: {
                        Text("下訂單")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
        }
        .navigationTitle("購物車")
        .alert("系統訊息", isPresented: $showAlert) {
            
        } message: {
            Text(alertMsg)
        }

    }
}

struct ShoppingCarView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCarView()
    }
}

struct ShoppingCarCard: View {
    @Environment(\.managedObjectContext) var context
    let car: ShoppingCar
    
    @State var quantity: Int
    let onChange: () -> Void
    
    init (shoppingCar: ShoppingCar, onChange: @escaping () -> Void) {
        self.car = shoppingCar
        self.quantity = Int(car.quantity)
        self.onChange = onChange
    }
    
    var body: some View {
        HStack {
            if (car.product!.product_medias!.count > 0) {
                Image(uiImage: UIImage(data:  (car.product!.product_medias!.allObjects as! [ProductMedia]).first!.data!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit  )
            } else {
                Image("Changli")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack (alignment: .leading) {
                Text("賣家: \(car.product!.seller!.name!)")
                Text(car.product!.name ?? "")
                Text("$ \(car.product!.price)")
                
                Stepper(String(quantity), value: $quantity, in: 0...99, step: 1)
                    .onChange(of: quantity) { newValue in
                        if (newValue == 0) {
                            context.delete(car)
                        } else {
                            car.quantity = Int64(newValue)
                        }
                        try! context.save()
                        onChange()
                    }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 200)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black, lineWidth: 2)
        }
    }
}
