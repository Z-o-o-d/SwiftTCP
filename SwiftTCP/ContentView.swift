import SwiftUI
import Network

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var tcpConnection: NWConnection?
    @State private var connectionStatus: String = "未连接"
    @State private var isConnected: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("请输入内容", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    self.setupConnection()
                }) {
                    Text("建立连接")
                        .padding()
                        .foregroundColor(.white)
                        .background(isConnected ? Color.gray : Color.green)
                        .cornerRadius(8)
                }
                .disabled(isConnected) // 禁用按钮，如果已经连接
                
                Button(action: {
                    self.cancelConnection()
                }) {
                    Text("断开连接")
                        .padding()
                        .foregroundColor(.white)
                        .background(isConnected ? Color.red : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!isConnected) // 禁用按钮，如果没有连接
            }
            
            Button(action: {
                self.sendDataOverTCP()
            }) {
                Text("发送数据到 192.168.7.184:1347")
                    .padding()
                    .foregroundColor(.white)
                    .background(isConnected ? Color.blue : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!isConnected) // 禁用按钮，如果没有连接

            Text("连接状态: \(connectionStatus)")
                .padding()
                .foregroundColor(.gray)
        }
        .padding()
    }

    private func setupConnection() {
        let host = NWEndpoint.Host("192.168.7.184")
        let port = NWEndpoint.Port(integerLiteral: 1347)
        
        tcpConnection = NWConnection(host: host, port: port, using: .tcp)
        
        tcpConnection?.stateUpdateHandler = { newState in
            DispatchQueue.main.async {
                switch newState {
                case .ready:
                    self.connectionStatus = "已建立连接"
                    self.isConnected = true
                    print("TCP 连接已建立")
                case .cancelled:
                    self.connectionStatus = "已取消连接"
                    self.isConnected = false
                    print("TCP 连接已取消")
                case .failed(let error):
                    self.connectionStatus = "连接失败: \(error)"
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
        connectionStatus = "已取消连接"
        isConnected = false
    }

    private func sendDataOverTCP() {
        guard let tcpConnection = tcpConnection else {
            print("连接未建立")
            self.connectionStatus = "连接未建立"
            return
        }
        
        tcpConnection.send(content: inputText.data(using: .utf8), completion: .contentProcessed { error in
            if let error = error {
                print("发送数据失败：\(error)")
            } else {
                print("发送数据成功：\(self.inputText)")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
