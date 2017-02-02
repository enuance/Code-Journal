/*
 Stephen Martinez's Code Journal Entry for concepts in Networking with Swift.
 
 A majority of these concepts utilize the URLSession Framework to provide a window in working
 with content within a network.
 */

import UIKit

class NetRetrievalViewController: UIViewController{
    //An Outlet to the view for an image.
    @IBOutlet weak var webImage: UIImageView!
    
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
                    self.webImage.image = downLoadedCatImage
                }
            }
        }
        //Every task starts in the suspended state and needs to have resume() called on it in order
        //for it to proceede as declared.
        networkingTask.resume()
    }
    
    
}