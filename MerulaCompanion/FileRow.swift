//
//  FileRow.swift
//  MerulaCompanion
//
//  Created by Lukas Mauffré on 21/04/2025.
//

import SwiftUI

struct FileRow: View {
    let label: String
    @Binding var path: String
    let allowedTypes: [String]
    
    var body: some View {
        HStack {
            Text(label)
            TextField("", text: $path)
                .textFieldStyle(.roundedBorder)
            Button("Choose…") {
                let panel = NSOpenPanel()
                panel.allowedFileTypes = allowedTypes
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK, let url = panel.url {
                    path = url.path
                }
            }
        }
    }
}
