//
//  ContentView.swift
//  SwiftTCP
//
//  Created by 何金泽 on 2024/6/25.
//

import SwiftUI

struct indexView: View {
    
    @State private var inputText: String = ""
    var body: some View {
            VStack(spacing: 20) {
                
                
                TextField("请输入内容", text: $inputText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button(action: {
                                print("输入的内容是：\(self.inputText)")
                            }) {
                                Text("打印输入内容")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }

                Button(action: {
                    // 按钮被点击时的操作
                    print("Sun button tapped")
                }) {
                    Image(systemName: "sun.max.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                
                Button(action: {
                    // 按钮被点击时的操作
                    print("Folder button tapped")
                }) {
                    Image(systemName: "folder.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
                
                Button(action: {
                    // 按钮被点击时的操作
                    print("Person button tapped")
                }) {
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                }
            }
            .padding()
        }
}

#Preview {
    indexView()
}
