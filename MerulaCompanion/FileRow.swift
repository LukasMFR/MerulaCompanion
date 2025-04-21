//
//  FileRow.swift
//  MerulaCompanion
//
//  Created by Lukas Mauffré on 21/04/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileRow: View {
    let label: String
    @Binding var path: String
    let allowedTypes: [String] // ex. ["ipsw"], ou ["*"] pour tout autoriser
    
    var body: some View {
        HStack {
            Text(label)
            TextField("", text: $path)
                .textFieldStyle(.roundedBorder)
            Button("Choose…") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                
                if !allowedTypes.contains("*") {
                    // Convertit les extensions en UTType
                    panel.allowedContentTypes = allowedTypes.compactMap {
                        UTType(filenameExtension: $0)
                    }
                }
                if panel.runModal() == .OK, let url = panel.url {
                    path = url.path
                }
            }
        }
    }
}
