import Cocoa

class FolderStructureManager {

    func createFolderStructure(for projectFolderURL: URL, in projectDirectory: URL, with liveActionCheckbox: NSButton, _ animation2DCheckbox: NSButton, _ animation3DCheckbox: NSButton) {
        let folderStructureURL = projectDirectory.appendingPathComponent("folder_structure")
        
        if !FileManager.default.fileExists(atPath: folderStructureURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderStructureURL, withIntermediateDirectories: true, attributes: nil)
                for projectType in ["Live Action", "2D Animation", "3D Animation"] {
                    let subfolders = getSubfolders(for: projectType)
                    for (parentFolder, children) in subfolders {
                        let parentURL = folderStructureURL.appendingPathComponent("\(projectType)/\(parentFolder)")
                        try FileManager.default.createDirectory(at: parentURL, withIntermediateDirectories: true, attributes: nil)
                        for child in children {
                            let childURL = parentURL.appendingPathComponent(child)
                            try FileManager.default.createDirectory(at: childURL, withIntermediateDirectories: true, attributes: nil)
                        }
                    }
                }
                print("Folder structure created successfully.")
            } catch {
                print("Failed to create folder structure template: \(error)")
            }
        }
        
        if liveActionCheckbox.state == .on {
            copySubfolders(from: folderStructureURL.appendingPathComponent("Live Action"), to: projectFolderURL)
        }
        if animation2DCheckbox.state == .on {
            copySubfolders(from: folderStructureURL.appendingPathComponent("2D Animation"), to: projectFolderURL)
        }
        if animation3DCheckbox.state == .on {
            copySubfolders(from: folderStructureURL.appendingPathComponent("3D Animation"), to: projectFolderURL)
        }
    }

    private func copySubfolders(from sourceURL: URL, to destinationURL: URL) {
        do {
            let fileManager = FileManager.default
            let subfolders = try fileManager.contentsOfDirectory(atPath: sourceURL.path)
            for subfolder in subfolders {
                let srcURL = sourceURL.appendingPathComponent(subfolder)
                let destURL = destinationURL.appendingPathComponent(subfolder)
                try fileManager.copyItem(at: srcURL, to: destURL)
                print("Copied \(srcURL.path) to \(destURL.path)")
            }
        } catch {
            print("Failed to copy subfolders from \(sourceURL.path) to \(destinationURL.path): \(error)")
        }
    }
}
