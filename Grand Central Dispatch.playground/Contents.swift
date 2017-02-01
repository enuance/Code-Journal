/*
 Stephen Martinez's Code Journal Entry for Grand Central Dispatch
 
 Grand Central Dispatch is the framework used for easily implementing multi-threading in order to create
 apps that run time consuming (user perceivable) processes, while still maintaining a responsive UI.
 A common scenario for the use of GCD includes any apps that accesses a database or uses the internet.
 
 If the main queue is blocked by a long running process then the user may experience a chopiness or
 outright freezing of the app.
*/

import UIKit

//Sample Imgages to place in sample threads.
enum SampleImages: String {
    case tulips = "https://homepages.cae.wisc.edu/~ece533/images/tulips.png"
    case retroLiz = "https://homepages.cae.wisc.edu/~ece533/images/frymire.png"
    case monarch = "https://homepages.cae.wisc.edu/~ece533/images/monarch.png"
}

class PhotoViewController: UIViewController {
    //The outlet to view our retrieved photos in.
    @IBOutlet weak var photoView: UIImageView!
    //A Spinner to show when the app is retrieving.
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    //A data validating property for last example.
    var lastPressedButton: UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the Spinner's Style, Color, and default to hide when it stops.
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = UIColor.cyan
        spinner.hidesWhenStopped = true
    }
    
    //A Method to shows multi-threading with reusable Queues and quality of service priorities.
    @IBAction func downLoadWithReusableQueue(_ sender: UIButton) {
        //Activate the spinner to communicate that retrieval has begun.
        spinner.startAnimating()
        //Place the code that blocks the main queue onto a concurrent queue so that the UI can remain
        //responsive. Grab a reusable queue by calling DispatchQueue.global. This take a quality of 
        //service argument which provides a prioritization for code to be completed. Then state whether
        //the queue should be executed in a serialized (synchronous) or immediately executed (asynchronous)
        //manner.The code in the trailing closure is then assigned to and executed on that queue.
        DispatchQueue.global(qos: .userInteractive).async {
            //Unwrap the optionals for use.
            if let url = URL(string: SampleImages.tulips.rawValue){
                let imageData = try? Data(contentsOf: url)
                if let imageData = imageData{
                    //!!NEVER!! Use View referencing / altering objects (that have UI in front of it or view in its
                    //name) outside of the main queue because it will cause unpredictable behavior, unless it is a
                    // "thread safe" object such as UIImage!
                    let image = UIImage(data: imageData)
                    //When you want to jump back to update the main queue (View Objects) with the potentially
                    //blocking data, then call DispatchQueue.main.async (or sync if you want ordered, but beware)
                    //and place your update data within the trailing closure. Make sure to be explicit and refrence
                    //self within closures - this keeps the objects in the heap until it is returned. You could
                    //optionally use the "weak" reference if you want the opposite.
                    DispatchQueue.main.async {
                        //If this code is running then the concurrent queue has finished and we can stop the spinner.
                        self.spinner.stopAnimating()
                        //Asign the retrieved image
                        self.photoView.image = image
                    }
                }
            }
        }
    }
    
    //A Method to show multi-threading with created queues. Creating your own queue rather than utiliziing
    //an existing queue can provide greater flexibility of use. For example you can suspend or resume your
    //created queue. In general it's implemented quitesimilarly.
    @IBAction func downloadWithCreatedQueue(_ sender: UIButton) {
        //Activate the spinner
        spinner.startAnimating()
        //Declare a queue to be created.
        let createdQueue = DispatchQueue(label: "MyCreatedQueue")
        //Asign your queue as a synchronous or asynchronous and place the code in the the closure.
        createdQueue.async {
            //Unwrap your properties for use.
            if let url = URL(string: SampleImages.monarch.rawValue){
                let imageData = try? Data(contentsOf: url)
                if let imageData = imageData{
                    //UIImage is "thread-safe" but for the most part keep View objects on the main queue!
                    let image = UIImage(data: imageData)
                    //Call the main queue and update your View with the retrieved data.
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.photoView.image = image
                    }
                }
            }
        }
    }
    
    
    //Sometimes a user may change their mind while waiting for the image to return. If they select another
    //image while waiting in the previous examples, then the user may experience a flutter, back and forth
    //between images as they are both brought back to the view. To prevent this, you can create some
    //property that can be checked in order to validate the returned data before it updates the view.
    @IBAction func downloadAndCheck(_ sender: UIButton){
        //Assigning a value to validate against before the view is updated.
        lastPressedButton = sender
        spinner.startAnimating()
        var url: URL? = nil
        //This example assumes three buttons connected to this method.
        switch sender.titleLabel!.text!{
        case "Tulips": url = URL(string: SampleImages.tulips.rawValue)
        case "Lizard": url = URL(string: SampleImages.retroLiz.rawValue)
        case "Monarch": url = URL(string: SampleImages.monarch.rawValue)
        default: break
        }
        //Everything is the same as previous examples except for the line after main thread call.
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = url{
                let imageData = try? Data(contentsOf: url)
                if let imageData = imageData{
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        //Checks to see if the user has selected another button before we came back from background.
                        if sender == self.lastPressedButton{
                            //If the data we have coincides with the last button pressed then proceed to update view
                            self.spinner.stopAnimating()
                            self.photoView.image = image
                        }else{
                            //Otherwise we ignore the data brought in order to allow the latest background thread to
                            //update the view.
                            print("Image ignored due to selection change")
                        }
                    }
                }
            }
        }
    }
    
}
