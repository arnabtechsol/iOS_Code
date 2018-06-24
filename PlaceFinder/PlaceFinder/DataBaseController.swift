

import UIKit
import CoreData

class DataBaseController: NSObject {
    
    class func saveInPlace(objDataToSave : DataModel)
    {
        
        let contextSave = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Place", in: contextSave)
        
        let objectTable = NSManagedObject(entity: entity!, insertInto: contextSave)
        
        //set the entity values
        objectTable.setValue(objDataToSave.address, forKey: "address")
        objectTable.setValue(objDataToSave.placeid, forKey: "placeid")
        objectTable.setValue(objDataToSave.lat, forKey: "lat")
        objectTable.setValue(objDataToSave.long, forKey: "long")
        objectTable.setValue(objDataToSave.searchString, forKey: "search_string")
        //save the object
        do {
            try contextSave.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save Trivia_Question \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    
    class func fetchFromPlaceAllSavedData() ->[DataModel]
    {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
//        let predicate = NSPredicate(format: "placeid == %@", placeid)
//        fetchRequest.predicate = predicate
        var arrDataModel = [DataModel]()
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                //print("\(String(describing: trans.value(forKey: "title")))")
                let objDataModel = DataModel()
                objDataModel.address = (String(describing: trans.value(forKey: "address")!))
                objDataModel.placeid = (String(describing: trans.value(forKey: "placeid")!))
                objDataModel.lat = trans.value(forKey: "lat") as! Double
                objDataModel.long = trans.value(forKey: "long") as! Double
                arrDataModel.append(objDataModel)
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return arrDataModel
    }
    
    class func fetchFromPlace(placeidSend : String, searchText : String) ->[DataModel] {
        let placeid = placeidSend
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        if placeidSend != ""
        {
            let predicate = NSPredicate(format: "placeid == %@", placeid)
            fetchRequest.predicate = predicate
        }
        else
        {
            let predicate = NSPredicate(format: "search_string == %@", searchText)
            fetchRequest.predicate = predicate
        }
        
        var arrDataModel = [DataModel]()
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                //print("\(String(describing: trans.value(forKey: "title")))")
                let objDataModel = DataModel()
                objDataModel.address = (String(describing: trans.value(forKey: "address")!))
                objDataModel.placeid = (String(describing: trans.value(forKey: "placeid")!))
                objDataModel.lat = trans.value(forKey: "lat") as! Double
                objDataModel.long = trans.value(forKey: "long") as! Double
                arrDataModel.append(objDataModel)
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return arrDataModel
    }
    
    class func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func deleteFromPlace(placeid : String)
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteId = placeid
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        deleteFetch.predicate = NSPredicate(format: "placeid == %@", deleteId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

}
