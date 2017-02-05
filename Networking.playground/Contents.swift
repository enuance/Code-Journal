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

//Here's another example of a viewcontroller that accesses the Flickr API (using JSON) to bring back various photo's
class FlickerViewerController: UIViewController {

    //Outlets for updating the view with the images retrieved, their titles and a button to disable when working.
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
        //Puts the Method parameter into an Array of tuples to be joined later into one final API method call
        let methodParameters: [(String, Any)] = [
            ("method", /*...............*/"flickr.galleries.getPhotos"),
            ("api_key", /*..............*/"9215bde.........rest of your key here"),
            ("gallery_id", /*...........*/"66911286-72157647263150569"),
            ("extras", /*...............*/"url_m"),
            ("format", /*...............*/"json"),
            ("nojsoncallback", /*.......*/"1")
        ]
        
        let urlString = "https://api.flickr.com/services/rest/" + myEscapedParameters(methodParameters)
        let url = URL(string: urlString)!
        //Use NSMutableURL(_:) instead of URLRequest(_:)in order to change the request.httpMethod type from get to something
        //else, otherwise default is "Get"
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request){ (data, status, error) in //Closure begins here
            // Method for displaying errors thoughout the URL Session
            func displayError(_ error: String) {
                print(error); print("URL at time of error: \(url)")
                DispatchQueue.main.async { self.isUIEnabled(true) }
            }
            //Checking that the initial data returned from the data task hasn't returned nill
            guard (error == nil) else{displayError("Error with your Request!: \(error)") ; return}
            guard let data = data else{displayError("No Data returned!"); return}
            //We requested a JSON format which comes to us in a serialized byte format. We need to deserialize it.
            //JSON objects are bridgable to Foundation objects such as Arrays and Dicts after being deserialized. The incoming
            //JSON object will be a Dictionary where the Keys are known to be Strings within the Flickr API, but the values
            //can be AnyObject.
            let parsedResult: [String: AnyObject]!
            do{ parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]}
            catch{ displayError("Data: \(data) could not be parsed as JSON object!"); return}
            
            guard let photosDictionary = parsedResult["photos"] as? [String : AnyObject],
                let photoArray = photosDictionary["photo"] as? [[String:AnyObject]]
                else{displayError("Cannot find selected keys in parsed result!") ; return}
            
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDictionary = photoArray[randomPhotoIndex]
            
            guard let imageURLString = photoDictionary["url_m"] as? String,
                let imageTitle = photoDictionary["title"] as? String
                else{ displayError("Cannot find key in photo dictionary!");return}
            
            let imageURL = URL(string: imageURLString)
            
            if let imageData = try? Data(contentsOf: imageURL!){
                DispatchQueue.main.async {
                    self.flickrImageView.image = UIImage(data: imageData)
                    self.flickrTitleLabel.text = imageTitle
                    self.isUIEnabled(true)
                }
            }
            print(imageURLString)
            print(imageTitle)
        }
        task.resume()
    }
    
    //Ordered using a tuple type parameter in an array
    func myEscapedParameters(_ parameters: [(key: String, value: Any)]) -> String{
        if parameters.isEmpty{return ""}else{
            var keyValuePairs = [String]()
            for keyValueTuple in parameters{
                let value = "\(keyValueTuple.value)"
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                keyValuePairs.append(keyValueTuple.key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    
}



