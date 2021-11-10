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
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                            print(shareURL)
                            // todo: open contaiting app https://habr.com/ru/company/mobileup/blog/441890/
                        }
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
                    })
                }
            }
        }
    }
//
//
//    override func didSelectPost() {
//        print("didSelectPost")
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
//        print(attachments)
//        var link: String = ""
//        for attachment in attachments{
//            print("attachment \(attachment)")
//            link = attachment.description
//        }
//        //  TODO: copy link to clipboard -> open app
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }

//    override func configurationItems() -> [Any]! {
//        var configurations: [SLComposeSheetConfigurationItem] = []
//        var podcasts: [PodcastInList] = []
//        podcasts = try! self.getPodcasts()
//        for podcast in podcasts{
//            let c = SLComposeSheetConfigurationItem()!
//            c.title = podcast.name
//            c.value = String(podcast.id)
//            configurations.append(c)
//        }
//        return configurations
//    }
    
    
    func getPodcasts() throws -> [PodcastInList]{
        // TODO: get real podcasts here
        return [
            PodcastInList(id: 1, name: "My Podcast 1"),
            PodcastInList(id: 2, name: "Test Podcast2"),
        ]
        
//        let defaults = UserDefaults.standard
//        let decoder = JSONDecoder()
//        let srcData = defaults.object(forKey: "podcasts") as! Data
//        print("Defaults \(srcData)")
//        let podcasts: [PodcastInList] = try decoder.decode([PodcastInList].self, from: srcData)
//        return podcasts
    }
    

}
