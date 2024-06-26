import SwiftUI
import Network
import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        guard let windowScene = self.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var ipParts: [Int] = [192, 168, 7, 184]
    @State private var portParts: [Int] = [0, 1, 3, 4, 7] // 调整端口的波轮左边一位
    @State private var tcpConnection: NWConnection?
    @State private var isConnected: Bool = false
    @State private var receivedData: [String] = []
    @State private var cachedData: [(timestamp: String, data: String)] = []
    @State private var sendCount: Int = 0
    @State private var receiveCount: Int = 0
    @State private var showWheelPickers: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    Button(action: {
                        self.setupConnection()
                        self.triggerImpactFeedback()
                    }) {
                        Text("建立连接")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .disabled(isConnected)
                    .opacity(isConnected ? 0.5 : 1.0)

                    Button(action: {
                        self.cancelConnection()
                        self.triggerImpactFeedback()
                        UIApplication.shared.endEditing(true)
                    }) {
                        Text("断开连接")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .disabled(!isConnected)
                    .opacity(!isConnected ? 0.5 : 1.0)

                    Button(action: {
                        self.sendCloseCommand()
                        self.triggerImpactFeedback()
                        UIApplication.shared.endEditing(true)
                    }) {
                        Text("关闭连接")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .disabled(!isConnected)
                    .opacity(!isConnected ? 0.5 : 1.0)

                    
                }

                if showWheelPickers {
                    HStack(spacing: 0) {
                        ForEach(0..<ipParts.count, id: \.self) { index in
                            Picker("", selection: $ipParts[index]) {
                                ForEach(0..<256) { number in
                                    Text("\(number)").tag(number)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: geometry.size.width / 6, height: geometry.size.height / 8)
                            .clipped()
                        }
                    }
                    .padding()

                    HStack(spacing: 0) {
                        ForEach(0..<portParts.count, id: \.self) { index in
                            Picker("", selection: $portParts[index]) {
                                ForEach(0..<10) { number in
                                    Text("\(number)").tag(number)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: geometry.size.width / 10, height: geometry.size.height / 8)
                            .clipped()
                        }
                    }
                    .padding()
                }

                HStack {
                    Text("远程IP:")
                        .foregroundColor(.gray)
                    Text("\(ipString())")
                    Text(":")
                        .foregroundColor(.gray)
                    Text("\(portString())")
                    Button(action: {
                        withAnimation {
                            self.showWheelPickers.toggle()
                        }
                    }) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(showWheelPickers ? 180 : 90))
                            .animation(.easeInOut)
                    }
                }

                TextField("请输入内容", text: $inputText, onCommit: {
                    self.sendDataOverTCP()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()


                HStack(spacing: 20) {
                    
                    Button(action: {
                        self.saveDataToCSV()
                        self.triggerImpactFeedback()
                    }) {
                        Text("保存数据")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        self.clearCounters()
                        self.triggerImpactFeedback()
                    }) {
                        Text("清空计数")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        self.sendDataOverTCP()
                    }) {
                        Text("发送数据")
                            .padding()
                            .foregroundColor(.white)
                            .background(isConnected ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isConnected)
                }

                List(receivedData, id: \.self) { data in
                    Text("传感器数据: \(data)")
                }
                .padding()

                HStack {
                    Text("发送成功: \(sendCount)")
                    Spacer()
                    Text("接收成功: \(receiveCount)")
                }
                .padding(.vertical, 0.0)
                .foregroundColor(.gray)

                
            }
            .padding()
            .onTapGesture {
                UIApplication.shared.endEditing(true)
            }
        }
    }

    private func setupConnection() {
        guard let port = NWEndpoint.Port(portString()) else {
            return
        }

        let host = NWEndpoint.Host(ipString())

        tcpConnection = NWConnection(host: host, port: port, using: .tcp)

        tcpConnection?.stateUpdateHandler = { newState in
            DispatchQueue.main.async {
                switch newState {
                case .ready:
                    self.isConnected = true
                    print("TCP 连接已建立")
                    self.receiveData()
                case .cancelled:
                    self.isConnected = false
                    print("TCP 连接已取消")
                case .failed(let error):
                    self.isConnected = false
                    print("TCP 连接失败：\(error)")
                default:
                    break
                }
            }
        }

        tcpConnection?.start(queue: .global())
    }

    private func cancelConnection() {
        tcpConnection?.cancel()
        tcpConnection = nil
        isConnected = false
    }

    private func sendCloseCommand() {
        guard let tcpConnection = tcpConnection else {
            return
        }

        let closeCommand = "__CLOSE_ALL_TCP_CONNECT__"
        tcpConnection.send(content: closeCommand.data(using: .utf8), completion: .contentProcessed { error in
            if let error = error {
                print("发送关闭命令失败：\(error)")
            } else {
                print("发送关闭命令成功")
                self.cancelConnection()
            }
        })
    }

    private func sendDataOverTCP() {
        guard let tcpConnection = tcpConnection else {
            return
        }

        tcpConnection.send(content: inputText.data(using: .utf8), completion: .contentProcessed { error in
            if let error = error {
                print("发送数据失败：\(error)")
            } else {
                print("发送数据成功：\(self.inputText)")
                self.sendCount += 1
                self.triggerImpactFeedback()
            }
        })
    }

    private func receiveData() {
        tcpConnection?.receive(minimumIncompleteLength: 1, maximumLength: 1024, completion: { (data, context, isComplete, error) in
            if let data = data, !data.isEmpty {
                let receivedString = String(data: data, encoding: .utf8) ?? "无法解码数据"
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                DispatchQueue.main.async {
                    self.parseReceivedData(receivedString, timestamp: timestamp)
                }
                print("接收到数据: \(receivedString)")
                self.receiveCount += 1
                self.triggerImpactFeedback()
            }

            if let error = error {
                print("接收数据失败: \(error)")
            } else {
                self.receiveData()
            }
        })
    }

    private func parseReceivedData(_ dataString: String, timestamp: String) {
        guard dataString.hasPrefix("DATA:") else {
            return
        }

        let dataContent = dataString.replacingOccurrences(of: "DATA:", with: "")
        let sensorDataArray = dataContent.components(separatedBy: ",")
        self.receivedData = sensorDataArray
        self.cachedData.append((timestamp, dataString)) // 缓存带时间戳的数据
    }

    private func ipString() -> String {
        ipParts.map { String($0) }.joined(separator: ".")
    }

    private func portString() -> String {
        portParts.map { String($0) }.joined()
    }

    private func triggerImpactFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    private func clearCounters() {
        sendCount = 0
        receiveCount = 0
    }

    private func saveDataToCSV() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd_HHmm_ss"
        let fileName = "\(dateFormatter.string(from: Date()))_SensorData.csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        var csvText = "Timestamp,SensorData\n"
        for (timestamp, data) in cachedData {
            csvText.append("\(timestamp),\(data)\n")
        }

        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            print("CSV 文件已保存到：\(path)")
        } catch {
            print("保存 CSV 文件失败：\(error)")
        }
    }
}

#Preview {
    ContentView()
}
