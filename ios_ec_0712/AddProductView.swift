//
//  AddProductView.swift
//  ios_ec_0712
//
//  Created by Admin on 2024/7/12.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    @AppStorage("user_id") var userId: String?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)], animation: .default)
    var users: FetchedResults<User>
    
    @State var name = FormFieldViewModel(label: "產品名稱",placeholder: "請輸入產品名稱") { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        return nil
    }
    
    @State var summary = FormFieldViewModel(label: "產品敘述",placeholder: "請輸入暱稱", isMultipleLine: true) { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        return nil
    }
    
    @State var price = FormFieldViewModel(label: "價錢",placeholder: "請輸入價錢") { value in
        if value.isEmpty {
            return "欄位不可為空"
        }
        
        let a = Int(value)
        
        if (a == nil) {
            return "欄位必須為整數值"
        }
        
        if (a! < 1) {
            return "價錢至少須為 1 元"
        }
        
        return nil
    }
    
    @State var selectedPhotoData: [PhotosPickerItem] = []
    @State var selectedData: [Data] = []
    
    @State var alertMsg = ""
    @State var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                FormFieldView(model: name)
                FormFieldView(model: summary)
                FormFieldView(model: price)
                
                Text("產品照片（可選）")
                ScrollView (.horizontal) {
                    HStack (spacing: 10) {
                        ForEach(selectedData, id: \.self) { data in
                            Image(uiImage: UIImage(data: data)!)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        
                        PhotosPicker("點我新增圖片", selection: $selectedPhotoData, maxSelectionCount: 10, matching: .images,  photoLibrary: .shared())
                            .onChange(of: selectedPhotoData) { newValue in
                                selectedData.removeAll()
                                
                                newValue.forEach { item in
                                    item.loadTransferable(type: Data.self) { r in
                                        selectedData.append(try! r.get()!)
                                    }
                                }
                            }
                        
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        let results = [name.validate(), summary.validate(), price.validate()]
                        
                        if (results.contains(false)) {
                            return;
                        }
                        
                        
                            let current = users.first { a in
                                a.id?.uuidString == userId
                            }
                        
                        let product = Product(context: context)
                        product.id = UUID()
                        product.name = name.value
                        product.summary = summary.value
                        product.price = Int64(Int(price.value)!)
                        product.seller = current!
                        var index = 1
                        product.product_medias = NSSet(array: selectedData.map({ data
                            in
                            let media = ProductMedia(context: context)
                            media.id = UUID()
                            media.order_no = Int64(index)
                            index += 1
                            media.data = data
                            
                            return media
                        }))
                        
                        try! context.save()
                        
                        alertMsg = "商品新增成功"
                        showAlert = true
                    } label: {
                        Text("確認新增")
                            .frame(width: 150, height: 30)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
        }
        .navigationTitle("新增商品")
        .navigationBarTitleDisplayMode(.inline)
        .alert("系統訊息", isPresented: $showAlert) {
            Button {
                if (alertMsg == "商品新增成功")
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

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
