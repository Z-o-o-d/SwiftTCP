import SwiftUI

@main
struct MySwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            
            TabView {
                ContentView()
                    .tabItem {
                        Label("TCP", systemImage: "network")
                    }
                FileSaveView()
                    .tabItem {
                        Label("FILEs", systemImage: "externaldrive")
                    }
//                MAPs()
//                    .tabItem {
//                        Label("MAP", systemImage: "location")
//                    }
                Setting()
                    .tabItem {
                        Label("ABOUT", systemImage: "person")
                    }
//                
            }
        }
    }
}
