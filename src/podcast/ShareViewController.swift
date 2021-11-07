import UIKit
import Social
import podcast

struct PodcastInList: Codable, Hashable {
    let id: Int
    let name: String
}

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
        var configurations: [SLComposeSheetConfigurationItem] = []
        var podcasts: [PodcastInList] = []
        podcasts = try! self.getPodcasts()
//        do{
//
//        } catch{
//            podcasts = []
//        }
//
        for podcast in podcasts{
            let c = SLComposeSheetConfigurationItem()!
            c.title = podcast.name
            c.value = String(podcast.id)
            configurations.append(c)
        }
        return configurations
    }
    
    
    func getPodcasts() throws -> [PodcastInList]{
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
//        let srcData = String(data: defaults.object(forKey: "podcasts") as! Data, encoding: .utf8)
        let srcData = defaults.object(forKey: "podcasts") as! Data
        print("Defaults \(srcData)")
//        let string = String(data: data, encoding: .utf8)!
        let podcasts: [PodcastInList] = try decoder.decode([PodcastInList].self, from: srcData)
        return podcasts
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
