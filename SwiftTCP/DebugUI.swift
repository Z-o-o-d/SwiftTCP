import SwiftUI

struct DebugInfoView: View {
    @State private var consoleOutput: String = ""
    
    var body: some View {
        VStack {
            Text("Console Output")
                .font(.headline)
                .padding()
            
            ScrollView {
                Text(consoleOutput)
                    .padding()
                    .onAppear {
                        // Simulate some print statements
                        for i in 1...10 {
                            print("Print statement \(i)")
                            consoleOutput.append("Print statement \(i)\n")
                        }
                    }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.secondary.opacity(0.1))
        }
        .padding()
    }
}

struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        DebugInfoView()
    }
}
