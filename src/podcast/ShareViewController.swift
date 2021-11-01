import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true

    }

    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.handleSharedLink()
    }
    
    private func handleSharedLink() {
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        print(attachments)
    }

    override func didSelectPost() {
        print("didSelectPost")
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        print(attachments)

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
//import UIKit
//import MobileCoreServices
//
//@objc(ShareExtensionViewController)
//class ShareViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.handleSharedLink()
//    }
//
//    private func handleSharedLink() {
//        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
//        print(attachments)
//    }
//
////    override func configurationItems() -> [Any]! {
////        super.configurationItems()
////        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
////        return []
////    }
//}
