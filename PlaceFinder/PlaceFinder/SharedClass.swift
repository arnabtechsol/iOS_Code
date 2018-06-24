
import UIKit

class SharedClass: NSObject {
    
    class var sharedInstance: SharedClass {
        struct Static {
            static let instance = SharedClass()
        }
        return Static.instance
    }
    
    var objSearchResultArray = [BaseClass]()
    var searchString = String()
    
    class func showAlert(message : String, classInstance : UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        classInstance.present(alert, animated: true, completion: nil)
    }
}
