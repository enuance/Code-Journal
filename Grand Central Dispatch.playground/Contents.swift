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
        //the queue should be executed in a FIFO ordered (synchronous) or unordered (asynchronous) manner.
        //The code in the trailing closure is then assigned to and executed on that queue.
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
    
    
    //A Method to show multi-threading with created queues.
    @IBAction func downloadWithCreatedQueue(_ sender: UIButton) {
        //Activate the spinner
        spinner.startAnimating()
        let createdQueue = DispatchQueue(label: "MyCreatedQueue")
        createdQueue.async {
            if let url = URL(string: SampleImages.monarch.rawValue){
                let imageData = try? Data(contentsOf: url)
                if let imageData = imageData{
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.photoView.image = image
                    }
                }
            }
        }
    }
    
    
    
}