/*
 Stephen Martinez's Code Journal Entry for concepts in Networking with Swift.
 
 A majority of these concepts utilize the URLSession Framework to provide a window in working
 with content within a network.
 */

import UIKit

class NetRetrievalViewController: UIViewController{
    //An Outlet to the view for an image.
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //We can start a networking session by calling URLSession() and then the type of task we want
        //to undertake. There are three types of Tasks: Data, Upload, Download
    
        //You can grab a Uniform Resource Locator by calling URL() and assigning it to a variable.
        let catImage = URL(string: "https://en.wikipedia.org/wiki/Cat#/media/File:AfricanWildCat.jpg")
        
        //Then you can call a shared (singleton) of a URLSession. Then utilize the instance property
        //for the type of task you want to do. The one here in the example is one that takes a 
        //URL and provides a closure in which you can handle the data with. This closure works in the
        //background so you'll likely need to utilize (GCD) dispatch.main to update the View with the
        //data returned.
        let networkingTask = URLSession.shared.dataTask(with: catImage!){ data, urlStatus, error in
            //If data for the url(catImage) returns then error will return nil, otherwise data will
            //return nill. The status (urlStatus) shows the response/header info of the url.
            if data != nil{
                //After checking that the data has returned we can then proceede to utilize the resource
                let downLoadedCatImage = UIImage(data: data!)
                //After capturing the resource we can then call the main thread and update the View.
                DispatchQueue.main.async {
                    self.photoImageView.image = downLoadedCatImage
                }
            }
        }
        //Every task starts in the suspended state and needs to have resume() called on it in order
        //for it to proceede as declared.
        networkingTask.resume()
    }
}


//..............................................................................................
//Here's another example of a ViewController that accesses the Flickr API (using JSON) to bring
//back various photo's
//..............................................................................................

class FlickerViewerController: UIViewController {
    //Outlets for updating the view with the images retrieved, their titles and a button to 
    //disable when working.
    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var flickrTitleLabel: UILabel!
    @IBOutlet weak var getImageButton: UIButton!
    
    //Get the Flickr image and disable the button until retireved.
    @IBAction func grabNewImage(_ sender: AnyObject) {
        isUIEnabled(false)
        getImageFromFlickr()
    }
    
    //Helper method to configure UI element enablement.
    func isUIEnabled(_ enabled: Bool) {
        flickrTitleLabel.isEnabled = enabled
        getImageButton.isEnabled = enabled
        if enabled { getImageButton.alpha = 1.0}
        else { getImageButton.alpha = 0.5}
    }
    
    //Method for gets a random image from the Flickr API.
    func getImageFromFlickr() {
        //Puts the Method parameter into an Array of tuples to be joined later into one final API 
        //method call
        let methodParameters: [(String, Any)] = [
            ("method", /*...............*/"flickr.galleries.getPhotos"),
            ("api_key", /*..............*/"9215bde.........rest of your key here"),
            ("gallery_id", /*...........*/"66911286-72157647263150569"),
            ("extras", /*...............*/"url_m"),
            ("format", /*...............*/"json"),
            ("nojsoncallback", /*.......*/"1")
        ]
        let urlString = "https://api.flickr.com/services/rest/" + webSafeFlickrParameters(methodParameters)
        let url = URL(string: urlString)!
        //Use NSMutableURL(_:) instead of URLRequest(_:)in order to change the request.httpMethod 
        //type from "Get" to something else, otherwise default is "Get"
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){ (data, status, error) in
            // Method for displaying errors thoughout the URL Session
            func displayError(_ error: String) {
                print(error); print("URL at time of error: \(url)")
                DispatchQueue.main.async { self.isUIEnabled(true) }
            }
            //Checking that the initial data returned from the data task hasn't returned nill
            guard (error == nil) else{displayError("Error with your Request!: \(error)") ; return}
            guard let data = data else{displayError("No Data returned!"); return}
            //We requested a JSON format which comes to us in a serialized byte format. We need to 
            //deserialize it first in order to work with relatable objects that are bridgable to 
            //Foundation objects such as Arrays and Dicts. The incoming JSON object will be a 
            //Dictionary where the Keys are known to be Strings within the Flickr API, but the values
            //can be AnyObject, so we should capture the JSON in a variable typed for that.
            let parsedResult: [String: AnyObject]!
            //deserializing JSON requires it to be done in a Do/try/catch block because it "throws"(can 
            //return an error).
            do{ parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]}
            catch{ displayError("Data: \(data) could not be parsed as JSON object!"); return}
            //Once deserialization is complete, we can travel through it by accessing keys or using 
            //other indexing methods depending on the object. However, we do have to navigate
            //cautiously using the guard statment because we aren't certain of what's comming to us.
            guard let photosDictionary = parsedResult["photos"] as? [String : AnyObject],
                let photoArray = photosDictionary["photo"] as? [[String:AnyObject]]
                else{displayError("Cannot find selected keys in parsed result!") ; return}
            //Creating a random indexing number based on the total photos in the array.
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            //Once we have the random photo we want we can then capture it's location and convert it
            //to a data type, which can then be converted to a usable image type.
            let photoDictionary = photoArray[randomPhotoIndex]
            guard let imageURLString = photoDictionary["url_m"] as? String,
                //Grabing the image title as well to update the photo info in the view.
                let imageTitle = photoDictionary["title"] as? String
                else{ displayError("Cannot find key in photo dictionary!");return}
            let imageURL = URL(string: imageURLString)
            //If the URL contains convertable data then we can proceed
            if let imageData = try? Data(contentsOf: imageURL!){
                //Being that this data task has been working on a background thread we'll have to call up
                //the main thread in order to update the view with our retrieved image, label, and UI
                //enablement command.
                DispatchQueue.main.async {
                    self.flickrImageView.image = UIImage(data: imageData)
                    self.flickrTitleLabel.text = imageTitle
                    self.isUIEnabled(true)
                }
            }
        }
        //The default for Data Tasks always begins in the suspended state. In order to execute the
        //task, URLSession.shared.dataTask.resume(_:) must be called in order to complete the 
        //assignement.
        task.resume()
    }
    
    //Helper Method to filter and ensure a web safe String (URL) to pass to the API. The method
    //takes an array of tuples containing a key and value pair and then filters and concatenates
    //as an ASCII websafe string.
    func webSafeFlickrParameters(_ parameters: [(key: String, value: Any)]) -> String{
        if parameters.isEmpty{return ""}else{
            var keyValuePairs = [String]()
            //Goes through all the Key-Value pairs
            for keyValueTuple in parameters{
                //Splits off the value to be converted into a websafe string.
                let value = "\(keyValueTuple.value)"
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                //Stores all the key-Value pairs in the Key=Value (webSafe) format
                keyValuePairs.append(keyValueTuple.key + "=" + "\(escapedValue!)")
            }
            //Concatenates and returns all the Key-Value pairs in correctly formated String, ready to
            //be conjoined with the base API Method call.
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    
}



