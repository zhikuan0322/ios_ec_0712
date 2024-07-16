//
//  MainView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ProductView()
            }
            .tabItem {
                Label("產品列表", systemImage: "cart.fill")
            }
            
            NavigationStack {
                PersonalView()
            }
            .tabItem {
                Label("個人資訊", systemImage: "person.fill")
            }
        }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
