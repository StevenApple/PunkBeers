
import UIKit
import CoreData

class NoteDetailsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var note: Note!
    
    var dataController:PunkBeerPersistentController!
    
    var saveObserverToken: Any?


    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    /// The accessory view used when displaying the keyboard
    var keyboardToolbar: UIToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("the notes here \(String(describing: note.attributedText))")
        if let creationDate = note.creationDate {
            navigationItem.title = dateFormatter.string(from: creationDate)
        }
        textView.attributedText = note.attributedText
        
        // keyboard toolbar configuration
        configureToolbarItems()
       // configureTextViewInputAccessoryView()
        
        addSaveNotificationObserver()
    }
    
    deinit {
        removeSaveNotificationObserver()
    }


}

// -----------------------------------------------------------------------------

// MARK: - UITextViewDelegate

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note.attributedText = textView.attributedText
        try? dataController.viewContext.save()
    }
}

// MARK: - Toolbar

extension NoteDetailsViewController {

    func makeToolbarItems() -> [UIBarButtonItem] {
       
       
        let bold = UIBarButtonItem(image: #imageLiteral(resourceName: "toolbar-bold"), style: .plain, target: self, action: #selector(boldTapped(sender:)))
       
        
        return [bold]
    }
    
    func configureToolbarItems() {
        toolbarItems = makeToolbarItems()
        navigationController?.setToolbarHidden(false, animated: false)
    }
    


    
    @IBAction func boldTapped(sender: Any) {
        let newText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        newText.addAttribute(.font, value: UIFont(name: "OpenSans-Bold", size: 22) as Any, range: textView.selectedRange)
        
        let selectedTextRange = textView.selectedTextRange
        
        textView.attributedText = newText
        textView.selectedTextRange = selectedTextRange
        note.attributedText = textView.attributedText
        try? dataController?.viewContext.save()
    }
    

    

}

extension NoteDetailsViewController {

    func addSaveNotificationObserver() {
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: dataController?.viewContext, queue: nil, using: handleSaveNotification(notification:))
    }
    
    func removeSaveNotificationObserver() {
        if let token = saveObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    fileprivate func reloadText() {
        textView.attributedText = note.attributedText
    }
    
    func handleSaveNotification(notification:Notification) {
        DispatchQueue.main.async {
            self.reloadText()
        }
    }
}

