
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var mapIndex: Int?
    var showAll = Bool()
    let objSharedInstance = SharedClass.sharedInstance
    var arraylat = [Float]()
    var arraylong = [Float]()
    @IBOutlet weak var btnSave: UIButton!
    
    let objDataModel = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.isHidden = true
        // Add mappoints to Map
        
        
        // Connect all the mappoints using Poly line.
       
        if showAll == true
        {
            for i in 0...((DataBaseController.fetchFromPlaceAllSavedData()).count-1) {
                var objDataModel = DataModel()
                objDataModel = (DataBaseController.fetchFromPlaceAllSavedData())[i]
                arraylat.append(Float(objDataModel.lat))
                arraylong.append(Float(objDataModel.long))
            }
            zoomToRegion(latZoom: 1000000, longZoom: 1500000)
        }
        else
        {
            var objDataModel = DataModel()
            objDataModel = (DataBaseController.fetchFromPlaceAllSavedData())[mapIndex!]
            arraylat.append((Float(objDataModel.lat)))
            arraylong.append((Float(objDataModel.long)))
            zoomToRegion(latZoom: 5000, longZoom: 7000)
        }

        
        
        

        
        mapView.delegate = self
        
        let annotations = getMapAnnotations()
        mapView.addAnnotations(annotations)
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for annotation in annotations {
            points.append(annotation.coordinate)
        }
        

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Zoom to region
    
    func zoomToRegion(latZoom : Double, longZoom : Double) {
        
        var objDataModel = DataModel()
        objDataModel = (DataBaseController.fetchFromPlaceAllSavedData())[mapIndex!]
        
        let location = CLLocationCoordinate2D(latitude:Double(objDataModel.lat), longitude: Double(objDataModel.long))
        
        let region = MKCoordinateRegionMakeWithDistance(location, latZoom, longZoom)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    //MARK:- Annotations
    
    func getMapAnnotations() -> [Station] {
        var annotations:Array = [Station]()
        
        
        //var annotation = MKAnnotation
        for i in 0...((arraylat.count)-1) {
            let lat =  arraylat[i]
            let long = arraylong[i]
            let annotation = Station(latitude: Double(lat), longitude: Double(long))
            
            var objDataModel = DataModel()
            objDataModel = (DataBaseController.fetchFromPlaceAllSavedData())[mapIndex!]
            
            annotation.title = objDataModel.address
            annotation.subtitle = "Coordinates: " + String(objDataModel.lat) + "," + String(objDataModel.long)
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let arrDataModel = DataBaseController.fetchFromPlace(placeidSend: ((view.annotation?.subtitle)!)!, searchText: "")
        if arrDataModel.count > 0
        {
            // delete
            
            btnSave.setTitle("Delete", for: .normal)
        }
        else
        {
            btnSave.setTitle("Save", for: .normal)
            
        }
        objDataModel.address = ((view.annotation?.title)!)!
        objDataModel.lat = (view.annotation?.coordinate.latitude)!
        objDataModel.long = (view.annotation?.coordinate.longitude)!
        objDataModel.placeid = ((view.annotation?.subtitle)!)!
        let objSharedInstance = SharedClass.sharedInstance
        objDataModel.searchString = objSharedInstance.searchString
        btnSave.isHidden = false
        
    }
    
    func action1() {
        
    }
    
    @IBAction func btnSavePress(_ sender: Any)
    {
        
        let arrDataModel = DataBaseController.fetchFromPlace(placeidSend: objDataModel.placeid, searchText: "")
        if arrDataModel.count > 0
        {
            // delete
            DataBaseController.deleteFromPlace(placeid: objDataModel.placeid)
            btnSave.setTitle("Save", for: .normal)

        }
        else
        {
            DataBaseController.saveInPlace(objDataToSave: objDataModel)
            btnSave.setTitle("Delete", for: .normal)

        }
        
        
    }
    

}






