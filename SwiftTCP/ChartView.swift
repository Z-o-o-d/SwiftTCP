//import SwiftUI
//import Charts
//import Network
//import UIKit
//
//struct ContentView: View {
//    @State private var inputText: String = ""
//    @State private var ipParts: [Int] = [192, 168, 7, 184]
//    @State private var portParts: [Int] = [0, 1, 3, 4, 7]
//    @State private var tcpConnection: NWConnection?
//    @State private var isConnected: Bool = false
//    @State private var receivedData: [String] = []
//    @State private var sendCount: Int = 0
//    @State private var receiveCount: Int = 0
//    @State private var showWheelPickers: Bool = false
//    @State private var showChartView: Bool = false
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 0) {
//                VStack(spacing: 10) {
//                    HStack(spacing: 20) {
//                        Button(action: {
//                            self.setupConnection()
//                            self.triggerImpactFeedback()
//                            UIApplication.shared.endEditing(true) // 收起键盘
//                        }) {
//                            Text("建立连接")
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(Color.green)
//                                .cornerRadius(8)
//                        }
//                        .disabled(isConnected)
//                        .opacity(isConnected ? 0.5 : 1.0)
//                        
//                        Button(action: {
//                            self.cancelConnection()
//                            self.triggerImpactFeedback()
//                            UIApplication.shared.endEditing(true)
//                        }) {
//                            Text("断开连接")
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(Color.red)
//                                .cornerRadius(8)
//                        }
//                        .disabled(!isConnected)
//                        .opacity(!isConnected ? 0.5 : 1.0)
//                        
//                        Button(action: {
//                            self.sendCloseCommand()
//                            self.triggerImpactFeedback()
//                            UIApplication.shared.endEditing(true)
//                        }) {
//                            Text("关闭连接")
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(Color.orange)
//                                .cornerRadius(8)
//                        }
//                        .disabled(!isConnected)
//                        .opacity(!isConnected ? 0.5 : 1.0)
//                    }
//                    
//                    if showWheelPickers {
//                        HStack(spacing: 0) {
//                            ForEach(0..<ipParts.count, id: \.self) { index in
//                                Picker("", selection: $ipParts[index]) {
//                                    ForEach(0..<256) { number in
//                                        Text("\(number)").tag(number)
//                                    }
//                                }
//                                .pickerStyle(WheelPickerStyle())
//                                .frame(width: geometry.size.width / 6, height: geometry.size.height / 8)
//                                .clipped()
//                            }
//                        }
//                        .padding(.all, 5.0)
//                        
//                        HStack(spacing: 0) {
//                            ForEach(0..<portParts.count, id: \.self) { index in
//                                Picker("", selection: $portParts[index]) {
//                                    ForEach(0..<10) { number in
//                                        Text("\(number)").tag(number)
//                                    }
//                                }
//                                .pickerStyle(WheelPickerStyle())
//                                .frame(width: geometry.size.width / 10, height: geometry.size.height / 8)
//                                .clipped()
//                            }
//                        }
//                        .padding()
//                    }
//                    
//                    HStack {
//                        Text("远程IP:")
//                            .foregroundColor(.gray)
//                        Text("\(ipString())")
//                        Text(":")
//                            .foregroundColor(.gray)
//                        Text("\(portString())")
//                        Button(action: {
//                            withAnimation {
//                                self.showWheelPickers.toggle()
//                            }
//                        }) {
//                            Image(systemName: "arrowtriangle.down.fill")
//                                .foregroundColor(.blue)
//                                .rotationEffect(.degrees(showWheelPickers ? 180 : 90))
//                        }
//                    }
//                    
//                    TextField("请输入发送内容", text: $inputText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        
//                    
//                    HStack {
//                        Button(action: {
//                            self.clearCounters()
//                            self.triggerImpactFeedback()
//                        }) {
//                            Text("清空计数")
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(Color.gray)
//                                .cornerRadius(8)
//                        }
//                        
//                        Button(action: {
//                            self.sendDataOverTCP()
//                            UIApplication.shared.endEditing(true)
//                        }) {
//                            Text("发送数据")
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(isConnected ? Color.blue : Color.gray)
//                                .cornerRadius(8)
//                        }
//                        .disabled(!isConnected)
//                    }
//                    .padding([.leading, .bottom, .trailing])
//                }
//                List(receivedData, id: \.self) { data in
//                    Text("数据 \(data)")
//                }
//                .padding()
//                
//                HStack {
//                    Text("发送成功: \(sendCount)")
//                    Spacer()
//                    Text("接收成功: \(receiveCount)")
//                }
//                .padding(.vertical, 0.0)
//                .foregroundColor(.gray)
//                
//                Button(action: {
//                    showChartView.toggle()
//                }) {
//                    Text("显示曲线图")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.purple)
//                        .cornerRadius(8)
//                }
//                .sheet(isPresented: $showChartView) {
//                    ChartView(receivedData: $receivedData)
//                }
//            }
//            .padding()
//            .onTapGesture {
//                UIApplication.shared.endEditing(true)
//            }
//        }
//    }
//
//    // Existing functions...
//
//    private func ipString() -> String {
//        ipParts.map { String($0) }.joined(separator: ".")
//    }
//
//    private func portString() -> String {
//        portParts.map { String($0) }.joined()
//    }
//
//    private func triggerImpactFeedback() {
//        let generator = UIImpactFeedbackGenerator(style: .medium)
//        generator.prepare()
//        generator.impactOccurred()
//    }
//
//    private func clearCounters() {
//        sendCount = 0
//        receiveCount = 0
//    }
//}
//
//struct ChartView: View {
//    @Binding var receivedData: [String]
//
//    var body: some View {
//        let dataEntries = receivedData.enumerated().compactMap { (index, data) -> ChartDataEntry? in
//            if let value = Double(data) {
//                return ChartDataEntry(x: Double(index), y: value)
//            }
//            return nil
//        }
//
//        let dataSet = LineChartDataSet(entries: dataEntries, label: "Received Data")
//        let data = LineChartData(dataSet: dataSet)
//
//        LineChartView(data: data)
//            .padding()
//    }
//}
//
//struct LineChartView: UIViewRepresentable {
//    var data: LineChartData
//
//    func makeUIView(context: Context) -> LineChartView {
//        let chartView = LineChartView()
//        chartView.data = data
//        return chartView
//    }
//
//    func updateUIView(_ uiView: LineChartView, context: Context) {
//        uiView.data = data
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
