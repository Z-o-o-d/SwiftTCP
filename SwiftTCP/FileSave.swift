import SwiftUI
import UIKit

struct FileSaveView: View {
    @State private var files: [URL] = []
    @State private var selectedFile: URL?
    @State private var showingFileViewer = false

    var body: some View {
        NavigationView {
            List {
                ForEach(files.sorted(by: { $0.lastPathComponent > $1.lastPathComponent }), id: \.self) { file in
                    Text(file.lastPathComponent)
                        .onTapGesture {
                            selectedFile = file
                            showingFileViewer = true
                        }
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
            .sheet(isPresented: $showingFileViewer) {
                if let selectedFile = selectedFile {
                    FileViewer(fileURL: selectedFile)
                }
            }
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
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.sourceView = rootViewController.view
                popoverPresentationController.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
                popoverPresentationController.permittedArrowDirections = []
            }
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

struct FileViewer: View {
    let fileURL: URL
    @State private var fileContent: String = ""
    @State private var fileName: String = ""

    var body: some View {
        VStack {
            Text(fileName)
                .font(.headline)
                .padding()
            
            ScrollView {
                Text(fileContent)
                    .padding()
            }
            .onAppear(perform: loadFileContent)
        }
        .onAppear {
            fileName = fileURL.lastPathComponent
        }
    }

    func loadFileContent() {
        do {
            fileContent = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            fileContent = "Error loading file content: \(error)"
        }
    }
}


#Preview {
    FileSaveView()
}
