import UIKit
import Social
import CoreServices

//
//class ShareViewController: SLComposeServiceViewController {
//
//    override func isContentValid() -> Bool {
//        print("isContentValid")
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
////    override func configurationItems() -> [Any]! {
////        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
////        return []
////    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
////            if let itemProvider = inputItem.attachments?.first {
////                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
////                    // do stuff!
////                }
////            }
////        }
//    }
//}


class ShareViewController: UIViewController {
    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)
    private var appURLString = "podcast://"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Get the all encompasing object that holds whatever was shared. If not, dismiss view.
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                return
        }
        // Check if object is of type URL
        if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            handleIncomingURL(itemProvider: itemProvider)
        } else {
            print("EXTENSION: Error: No url or text found")
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    
    private func handleIncomingURL(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { (item, error) in
            if let error = error {
                print("EXTENSION: URL-Error: \(error.localizedDescription)")
            }

            if let url = item as? NSURL, let urlString = url.absoluteString {
                print(urlString)
            }
            self.openMainApp()
//            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    // Courtesy: https://stackoverflow.com/a/44499222/13363449 👇🏾
    // Function must be named exactly like this so a selector can be found by the compiler!
    // Anyway - it's another selector in another instance that would be "performed" instead.
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURLString) else { return }
            _ = self.openURL(url)
        })
    }
}
