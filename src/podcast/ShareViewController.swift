import UIKit
import Social
import podcast
import SwiftUI

struct PodcastInList: Codable, Hashable {
    let id: Int
    let name: String
}

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

//    override func viewDidLoad() {
//        print("viewDidLoad")
//        super.viewDidLoad()
//        self.handleSharedLink()
//    }
//
//    private func handleSharedLink() {
//        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
//    }

    override func didSelectPost() {
        guard let url = URL(string: "podcast://") else { return }
        print(url)
        self.extensionContext?.open(url)
        
//        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
//            if let itemProvider = item.attachments?.first {
//                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
//                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
//                        if let shareURL = url as? NSURL {
////                            guard let url = URL(string: "PodcastAppURL://") else { return }
//                            guard let url = URL(string: "podcast://") else { return }
//                            print(url)
//                            
//                            print(self.extensionContext)
////                            UIApplication.open
////                            UIApplication.shared.open(url)
//                            self.extensionContext?.open(url)
////                            self.extensionContext?.open(url, completionHandler: {(_) -> Void in
////                                print("URL opened!")
////                            })
//                            // todo: open contaiting app https://habr.com/ru/company/mobileup/blog/441890/
//                        }
//                        self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
//                    })
//                }
//            }
//        }
    }
    
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
