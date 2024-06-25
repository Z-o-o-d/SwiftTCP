import SwiftUI
import MapKit
import Network


struct MapView: View {
    @State private var region: MKCoordinateRegion

    init() {
        // 初始化时设置初始位置
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 22.89, longitude: 113.88),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                // 每次视图出现时重置地图位置
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 22.89, longitude: 113.88),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
    }
}


struct MapView1: View {
    @State private var region: MKCoordinateRegion

    init() {
        // 初始化时设置初始位置
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 22.997, longitude: 113.84),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                // 每次视图出现时重置地图位置
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 22.997, longitude: 113.84),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
    }
}
struct MAPs: View {
    var body: some View {
        
        VStack {
            MapView1()
            MapView()
        }
        
    }
    
}

#Preview {
    MAPs()
}
