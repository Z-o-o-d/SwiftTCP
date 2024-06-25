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
                Setting()
                    .tabItem {
                        Label("ABOUT", systemImage: "person")
                    }
                MAPs()
                    .tabItem {
                        Label("MAP", systemImage: "location")
                    }
            }
        }
    }
}
