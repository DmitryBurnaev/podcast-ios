import UIKit
import Social
import CoreServices


class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
//                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
//                    // do stuff!
//                }
            }
        }
    }
}

//
//class ShareViewController: UIViewController {
//    private let typeText = String(kUTTypeText)
//    private let typeURL = String(kUTTypeURL)
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
//    }
//
//    // Courtesy: https://stackoverflow.com/a/44499222/13363449 👇🏾
//    // Function must be named exactly like this so a selector can be found by the compiler!
//    // Anyway - it's another selector in another instance that would be "performed" instead.
//    @objc func openURL(_ url: URL) -> Bool {
//        var responder: UIResponder? = self
//        while responder != nil {
//            if let application = responder as? UIApplication {
//                return application.perform(#selector(openURL(_:)), with: url) != nil
//            }
//            responder = responder?.next
//        }
//        return false
//    }
//
//}
