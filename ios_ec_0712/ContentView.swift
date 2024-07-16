//
//  ContentView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @State var mygo = false
    
    var body: some View {
        if (mygo) {
            MainView()
        } else {
            VStack {
                Image("Changli")
                    .resizable()
                    .frame(width: 256, height: 256)
                
                Text("電商購物平台")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    mygo = true
                })
                
//                let user = User(context: context)
//                user.id = UUID()
//                user.name = "Testing"
//                user.email = "A@A.COM"
//                user.password = "A"
//                user.is_seller = true
//
//                let product1 = Product(context: context)
//                product1.id = UUID()
//                product1.name = "TestingProduct1"
//                product1.price = 100
//                product1.summary = "Testing Product 1"
//
//                let product2 = Product(context: context)
//                product2.id = UUID()
//                product2.name = "TestingProduct2"
//                product2.price = 100
//                product2.summary = "Testing Product 2"
//
//                user.products = [product1, product2]
//
//                try! context.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
