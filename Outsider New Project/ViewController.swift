import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var liveActionCheckbox: NSButton!
    @IBOutlet weak var animation2DCheckbox: NSButton!
    @IBOutlet weak var animation3DCheckbox: NSButton!
    @IBOutlet weak var projectNameTextField: NSTextField!
    @IBOutlet weak var clientNameComboBox: NSComboBox!
    @IBOutlet weak var folderLocationButton: NSButton!
    @IBOutlet weak var directoryStatusLabel: NSTextField!
    @IBOutlet weak var submitButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    
    private var projectDirectory: URL?
    private var clientManager = ClientManager()
    private var folderStructureManager = FolderStructureManager()
    private var userSettings = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDirectoryStatusLabel()

        clientNameComboBox.usesDataSource = true
        clientNameComboBox.dataSource = self
        clientNameComboBox.delegate = self
    }

    @IBAction func chooseFolderButtonClicked(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a directory"
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == .OK {
            if let result = dialog.url {
                projectDirectory = result
                userSettings.set(result, forKey: "projectDirectory")
                updateDirectoryStatusLabel()
                clientManager.loadClientNames(from: result)
                clientNameComboBox.reloadData()
            }
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        guard let projectDirectory = projectDirectory else {
            showAlert(message: "Please select a project directory.")
            return
        }
        
        let clientName = clientNameComboBox.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let projectName = projectNameTextField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !clientName.isEmpty, !projectName.isEmpty else {
            showAlert(message: "Client Name and Project Name cannot be empty.")
            return
        }
        
        guard liveActionCheckbox.state == .on || animation2DCheckbox.state == .on || animation3DCheckbox.state == .on else {
            showAlert(message: "Please select at least one project type.")
            return
        }
        
        let sanitizedClientName = NamingConvention.transformName(clientName, style: .underscore)
        let sanitizedProjectName = NamingConvention.transformName(projectName, style: .underscore)
        
        let clientFolderURL = projectDirectory.appendingPathComponent(sanitizedClientName)
        let projectFolderURL = clientFolderURL.appendingPathComponent(sanitizedProjectName)
        
        if FileManager.default.fileExists(atPath: projectFolderURL.path) {
            showAlert(message: "A project with this name already exists.")
            return
        }
        
        do {
            try FileManager.default.createDirectory(at: projectFolderURL, withIntermediateDirectories: true, attributes: nil)
            folderStructureManager.createFolderStructure(for: projectFolderURL, in: projectDirectory, with: liveActionCheckbox, animation2DCheckbox, animation3DCheckbox)
            showAlert(message: "Project created successfully.")
        } catch {
            showAlert(message: "Failed to create project folders.")
        }
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }

    private func updateDirectoryStatusLabel() {
        if projectDirectory != nil {
            directoryStatusLabel.stringValue = "Selected: \(projectDirectory!.path)"
            directoryStatusLabel.textColor = .green
        } else {
            directoryStatusLabel.stringValue = "Confirm directory"
            directoryStatusLabel.textColor = .red
        }
    }

    private func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

extension ViewController: NSComboBoxDataSource, NSComboBoxDelegate {
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return clientManager.clientNames.count
    }

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return clientManager.clientNames[index]
    }

    func comboBoxSelectionDidChange(_ notification: Notification) {
        let selectedClient = clientNameComboBox.stringValue
        if !clientManager.clientNames.contains(selectedClient) {
            clientManager.clientNames.append(selectedClient)
            userSettings.set(clientManager.clientNames, forKey: "clientNames")
            clientNameComboBox.reloadData()
        }
    }
}
