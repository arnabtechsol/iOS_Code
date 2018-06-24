
import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var filtered:[String] = []
    let objSharedInstance = SharedClass.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil && searchBar.text != ""
        {
            objSharedInstance.searchString = searchBar.text!.lowercased()
            if (DataBaseController.fetchFromPlace(placeidSend: "", searchText: objSharedInstance.searchString)).count == 0
            {
                objSharedInstance.objSearchResultArray.removeAll()
                let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "")
                APIManagerClass.getBaseClassData(searchWord: searchText!)
                print(objSharedInstance.objSearchResultArray[0].results!)
                if objSharedInstance.objSearchResultArray[0].results != nil
                {
                    
                    if (objSharedInstance.objSearchResultArray[0].results?.count)! > 0
                    {
                        let count = (objSharedInstance.objSearchResultArray[0].results?.count)!
                        for i in 0..<count
                        {
                            let result : Results = (objSharedInstance.objSearchResultArray[0].results?[i])!
                            let objDataModel = DataModel()
                            objDataModel.lat = Double((result.geometry?.location?.lat)!)
                            objDataModel.long = Double((result.geometry?.location?.lng)!)
                            objDataModel.address = result.formattedAddress!
                            objDataModel.searchString = objSharedInstance.searchString
                            objDataModel.placeid = result.placeId!
                            DataBaseController.saveInPlace(objDataToSave: objDataModel)
                        }
                        
                    }
                    else
                    {
                        SharedClass.showAlert(message: "Free version of 'Google Place API' used to find one place, search for different place", classInstance: self)
                    }
                    
                    tableView.reloadData()
                }
                else
                {
                    let alert = UIAlertController(title: "Alert", message: "No data found", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                tableView.reloadData()
            }
            
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if (DataBaseController.fetchFromPlaceAllSavedData()).count > 0
        {
            if Double((DataBaseController.fetchFromPlaceAllSavedData()).count) > 1
            {
                return 2
            }
            else
            {
                return 1
            }
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if Double((DataBaseController.fetchFromPlaceAllSavedData()).count) == 0
        {
            return 1
        }
        else if Double((DataBaseController.fetchFromPlaceAllSavedData()).count) > 1
        {
            if section == 0
            {
                return 1
            }
            else
            {
                return (DataBaseController.fetchFromPlaceAllSavedData()).count
            }
        }
        else
        {
            return ((DataBaseController.fetchFromPlaceAllSavedData()).count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if Double(((DataBaseController.fetchFromPlaceAllSavedData()).count)) == 0
        {
            cell?.textLabel?.text = "No result available"
        }
        else if Double(((DataBaseController.fetchFromPlaceAllSavedData()).count)) > 1
        {
            if indexPath.section == 0
            {
                cell?.textLabel?.text = "Show All result"
            }
            else
            {
                var objDataModel = DataModel()
                objDataModel = (DataBaseController.fetchFromPlaceAllSavedData())[indexPath.row]
                cell?.textLabel?.text = objDataModel.address
            }
            
        }
        else
        {
            var objDataModel = DataModel()
            objDataModel = (DataBaseController.fetchFromPlaceAllSavedData())[indexPath.row]
            cell?.textLabel?.text = objDataModel.address
        }
        
        return cell!;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapViewController.mapIndex = indexPath.row
        
        if Double((DataBaseController.fetchFromPlaceAllSavedData()).count) == 0
        {
            SharedClass.showAlert(message: "Please Search Any Place", classInstance: self)
        }
        else if Double((DataBaseController.fetchFromPlaceAllSavedData()).count) > 1
        {
            if indexPath.section == 0 && indexPath.row == 0
            {
                mapViewController.showAll = true
            }
            else
            {
                mapViewController.showAll = false
            }
            self.navigationController?.pushViewController(mapViewController, animated: false)
        }
        else
        {
            mapViewController.showAll = false
            self.navigationController?.pushViewController(mapViewController, animated: false)
        }
        
    }
    
  

}

