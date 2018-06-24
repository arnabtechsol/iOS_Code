

import UIKit
import SwiftyJSON

class APIManagerClass: NSObject {
    
    class func getBaseClassData(searchWord : String)
    {
        var apiResponseBaseClass : BaseClass?
        let dictionaryForPointOfInterestDetails = APIManagerClass.getBaseClassDataApiCall(searchWord: searchWord)
       var jsonBody = Data()
        do {
            
            //Convert to Data
            jsonBody = try JSONSerialization.data(withJSONObject: dictionaryForPointOfInterestDetails, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let JSONString = String(data: jsonBody, encoding: String.Encoding.utf8) {
                print(JSONString)

                var responseDict: [[String: Any]] = [[:]]
                
                if let data = JSONString.data(using: .utf8) {
                    do {
                        responseDict = [try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]]
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                let objSharedInstance = SharedClass.sharedInstance
                for i in 0...(responseDict.count-1)
                {
                    let jsonResponse = JSON(responseDict[i] as [String: Any])
                    apiResponseBaseClass = BaseClass(json: jsonResponse)
                    objSharedInstance.objSearchResultArray.append(apiResponseBaseClass!)
                }
                
                
            }
            
        } catch {
        }

    }
    
    
    
    
    
    class func getBaseClassDataApiCall(searchWord : String) -> NSDictionary
    {
        var responseInfo = NSDictionary()
        let strUrlForSearch = "http://maps.googleapis.com/maps/api/geocode/json?address=" + searchWord + "&sensor=false"
        if let url = URL(string: strUrlForSearch)
        {
            do {
                let siteModelDataContents = try Data(contentsOf: url)
                print(siteModelDataContents)
                
                guard let json = try? JSONSerialization.jsonObject(with: siteModelDataContents) else {
                    
                    print("There was an error!")
                    return responseInfo
                }
                
                responseInfo = json as! NSDictionary
                
                
            } catch {
                responseInfo = [:]
                return responseInfo
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
        return responseInfo
        
    }
    
    
    
    class func convertToDictionary(jsonFile : String) -> [String: Any] {
        var responseString : String?
        var content : String?
        let path = Bundle.main.path(forResource: jsonFile, ofType: "json")
        do {
            content = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            responseString = content
            
        } catch
        {
            let nsError = error as NSError
            
            print(nsError.localizedDescription)
            print("No Such File")
        }
        
        var responseDict: [String: Any] = [:]
        
        if let data = responseString?.data(using: .utf8) {
            do {
                responseDict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return responseDict
    }

}
