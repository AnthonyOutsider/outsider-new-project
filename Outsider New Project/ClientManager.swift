import Foundation

class ClientManager {
    var clientNames: [String] = []

    func loadClientNames(from directory: URL) {
        clientNames.removeAll()
        do {
            let directories = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            clientNames = directories.filter { $0.hasDirectoryPath }.map { $0.lastPathComponent }
        } catch {
            print("Error loading client folders: \(error)")
        }
    }
}
