import SwiftUI

struct Setting: View {
    var body: some View {
        ScrollView { // Wrap content in ScrollView
            VStack {
                Image("huawei-harmonyos-next-1")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                Text("一次开发，多端部署")
                    .font(.title)
                Text("一套代码工程，一次开发上架，多端按需部署，支撑开发者快速高效的开发支持多种终端设备形态的应用，实现对不同设备兼容的同时，提供跨设备的流转、迁移和协同的分布式体验。")
                
                Image("kfpad2x")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                Text("自由流转")
                    .font(.title)
                Text("跨多设备的分布式操作，打破设备界限，多设备联动，典型场景有：媒体播控、应用接续、跨设备拖拽、跨设备剪贴板。")
                
                Image("ts-free-pad")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                Text("HarmonyOS 元服务")
                    .font(.title)
                Text("元服务是一种轻量程序形态，可独立分发、运行，实现业务闭环，具备免安装、服务直达和跨设备的特征，让服务触手可及，大幅提升信息与服务的效率。")
                Image("0619-yuanfuwu-pad")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                HStack {
                    VStack {
                        
                        
                        Image("ts-dyk-pc")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        Text("HarmonyOS 第一课")
                    }
                    VStack {
                        Image("240618004-pc")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        Text("HarmonyOS应用开发快速入门")
                    }
                }
                
                Spacer()
                
                Text("Powered By HarmonyOS NEXT")
                    .font(.footnote)
                    .padding(.bottom)
                Text("June 2024 Songshan Lake")
                    .font(.footnote)
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    Setting()
}
