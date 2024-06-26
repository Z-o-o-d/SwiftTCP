import SwiftUI
import UniformTypeIdentifiers

struct FileSaveView: View {
    @State private var files: [URL] = []
       
       var body: some View {
           NavigationView {
               List {
                   ForEach(files, id: \.self) { file in
                       Text(file.lastPathComponent)
                           .swipeActions(edge: .leading) {
                               Button(action: {
                                   exportFile(file)
                               }) {
                                   Label("Export", systemImage: "square.and.arrow.up")
                               }
                               .tint(.blue)
                           }
                           .swipeActions(edge: .trailing) {
                               Button(role: .destructive, action: {
                                   deleteFile(file)
                               }) {
                                   Label("Delete", systemImage: "trash")
                               }
                           }
                   }
               }
               .navigationTitle("Files")
               .onAppear(perform: loadFiles)
           }
       }
       
       func loadFiles() {
           let fileManager = FileManager.default
           if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
               do {
                   let directoryContents = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                   files = directoryContents
               } catch {
                   print("Error loading files: \(error)")
               }
           }
       }
       
       func deleteFile(_ file: URL) {
           let fileManager = FileManager.default
           do {
               try fileManager.removeItem(at: file)
               if let index = files.firstIndex(of: file) {
                   files.remove(at: index)
               }
           } catch {
               print("Error deleting file: \(error)")
           }
       }
       
       func exportFile(_ file: URL) {
           let activityViewController = UIActivityViewController(activityItems: [file], applicationActivities: nil)
           if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
               rootViewController.present(activityViewController, animated: true, completion: nil)
           }
       }
}

#Preview {
    FileSaveView()
}

