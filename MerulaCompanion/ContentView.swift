//
//  ContentView.swift
//  MerulaCompanion
//
//  Created by Lukas Mauffré on 21/04/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var runner = ProcessRunner()
    @State private var device: DeviceType = .A9
    @State private var operation: Operation = .getSHC
    @State private var ipswPath = ""
    @State private var shcPath = ""
    @State private var ptePath = ""
    @State private var blobPath = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Sélection du device & de l’opération
            HStack {
                Picker("Device type:", selection: $device) {
                    ForEach(DeviceType.allCases) { dt in
                        Text(dt.rawValue).tag(dt)
                    }
                }
                .pickerStyle(.segmented)
                
                Picker("Operation:", selection: $operation) {
                    ForEach(Operation.allCases) { op in
                        Text(op.rawValue).tag(op)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Sélecteurs de fichiers
            FileRow(label: "IPSW file:", path: $ipswPath, allowedTypes: ["ipsw"])
            if operation.requiresSHC { FileRow(label: "SHC block:", path: $shcPath, allowedTypes: ["*"]) }
            if operation.requiresPTE { FileRow(label: "PTE block:", path: $ptePath, allowedTypes: ["*"]) }
            if operation.requiresBlob { FileRow(label: "Blob file:", path: $blobPath, allowedTypes: ["shsh2"]) }
            
            // Bouton Run
            Button(action: launch) {
                Text("Run")
                    .frame(maxWidth: .infinity)
            }
            .keyboardShortcut(.defaultAction)
            .buttonStyle(.borderedProminent)
            
            // Console
            Text("Console output:")
                .font(.headline)
            ScrollView {
                Text(runner.output)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(4)
            }
            .frame(minHeight: 200)
        }
        .padding()
        .frame(minWidth: 700, minHeight: 600)
    }
    
    private func launch() {
        AuthorizationHelper.requestPrivilegesIfNeeded()
        
        let binDir = Bundle.main.resourceURL!
            .appendingPathComponent("bin", isDirectory: true)
            .path
        let exe = binDir + "/turdus_merula"
        
        let args = operation.buildArguments(
            device: device,
            ipsw: ipswPath,
            shc: shcPath,
            pte: ptePath,
            blob: blobPath)
        
        runner.run(executable: exe, arguments: args)
    }
}

#Preview {
    ContentView()
}
