import UIKit
import WebKit



class PostCodeSelectionViewController: UIViewController, WKScriptMessageHandler {
  
  var webView: WKWebView?
  
  var postCode = ""
  var address = ""
  let unwind = "unwind"
  
  override func loadView() {
    super.loadView()
    
    let contentController = WKUserContentController()
    contentController.add(self, name: "callBackHandler")
    
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    
    self.webView = WKWebView(frame: .zero, configuration: config)
    self.view = self.webView!
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard
      let url = URL(string: "https://trilliwon.github.io/postcode/"),
      let webView = webView else { return }
    
    let request = URLRequest(url: url)
    webView.load(request)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier, identifier == unwind {
      if let destination = segue.destination as? ViewController {
        destination.postCodeLabel.text = postCode
        destination.address1Label.text = address
      }
    }
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
    if let postCodData = message.body as? [String: Any] {
      postCode = postCodData["zonecode"] as? String ?? ""
      address = postCodData["addr"] as? String ?? ""
    }
    
    performSegue(withIdentifier: unwind, sender: nil)
  }
}
