//
//  ProcessRunner.swift
//  MerulaCompanion
//
//  Created by Lukas Mauffré on 21/04/2025.
//

import Foundation
import Combine

final class ProcessRunner: ObservableObject {
    @Published var output = ""
    private var ioPipe: Pipe?
    
    func run(executable: String, arguments: [String]) {
        output = ""
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments
        
        let pipe = Pipe()
        ioPipe = pipe
        process.standardOutput = pipe
        process.standardError = pipe
        
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty,
                  let line = String(data: data, encoding: .utf8),
                  let self = self else { return }
            DispatchQueue.main.async {
                self.output += line
            }
        }
        
        do {
            try process.run()
        } catch {
            DispatchQueue.main.async {
                self.output += "⚠︎ Error launching process: \(error.localizedDescription)\n"
            }
        }
    }
}
