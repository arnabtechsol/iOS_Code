# iOS_Code
I developed a demo app to cover some of my coding practices. 
The name of the app is PlaceFinder. This is a Universal app. It can run in iPhone and iPad.
The iOS version needed is iOS 10.0 and later. Pod swifty JSON installed. Open the PlaceFinder.xcworkspace file in Xcode 9.3.
The Swift Version 4.1.

The functionality of the app are the following:- 
The user can search any place through the app. Once you search a place the following has been handled inside the code.

1. "googleapis"  has been called and get the response.

2. Store the response using Core Data ( ORM database using SQLite).

3. Fetch the data from the local database and display it in the UITableView bellow the search bar.

4. Once the data saved in the local database and you want to search the same place then first, the app will check the place already exist or not in the local database. Then this will go for search using “googleapis”.

5.  If the user will tap on the searched data, then it will navigate to another page with the map. The search place will be annotated inside the map.

6. If user tap on the annotation then the coordinates of that place will be displayed and a  delete button will appear at the top section of the screen.  

7. If the user will delete the annotation by pressing the “Delete” button then the data of that particular place will be removed from the local database and the delete button will be turned in to save button. 

8. Now if the user wants to save the information again when the user has to press the “SAVE”  button.

9. If the user wants to delete the searched place permanently from the local database then, after pressing the delete button, the user just press back arrow from the navigation and user can see the data has been deleted.

Please note:- I used "googleapis" free version and there is a limit on search available.
