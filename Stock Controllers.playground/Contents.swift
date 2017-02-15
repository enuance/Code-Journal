/*
Created 2/14/17
Stephen Martinez's Code Journal Entry for using and manipulating Apple's Stock Controllers.
 */

import UIKit

///MARK: Segues & Navigation Pushes - Various methods

//Push Navigation with a Navigation Controller done programatically.....
//Assumes the ViewController is embedded in a Navigation Controller
class SomeController: UIViewController{
    //A property to pass through the Navagation.
    var someProperty: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the property value
        someProperty = "Valuable Data to Pass 😀"
    }
    
    //Programatic way of Segueing with Navigation Controller
    @IBAction func goToNewViewController(){
        //Instantiating the VC with StoryBoard method, using the identifier
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SomeIdentifierSetInStoryBoard") as! AnotherController
        //Communicate the property Value for use in new controller
        detailController.neededInfoProperty = self.someProperty
        //Push over to new controller
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
//When AnotherController appears it's property neededInfoProperty is set
class AnotherController: UIViewController{var neededInfoProperty: String!}

//.....................................................................

///Setting up a UIAlertController

class SomeClassContainingAnAlertController: UIViewController{
    @IBOutlet var share: UIButton!
    @IBOutlet var options: UIButton!
    
    @IBAction func alertMenu() {
        //Here we instantiate an alert controller menu & set the title
        let menu = UIAlertController()
        menu.title = "Options Menu"
        //Next we create the actions that we want to add to the Alert
        //controller. We kind of treat these like specialized functions
        //by inputing what we want them to do in the closure.
        
        //This action cancels the UIAlert Call
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){action in
            self.dismiss(animated: true, completion: nil)
        }
        
        //This action sets different colors for various objects
        let Cool = UIAlertAction(title: "cool", style: .default){action in
            self.view.backgroundColor = UIColor.init(red: CGFloat(0.25), green: CGFloat(0.5), blue: CGFloat(0.5), alpha: 1)
            self.share.setTitleColor(UIColor.white, for: .normal)
            self.options.setTitleColor(UIColor.white, for: .normal)
            self.dismiss(animated: true, completion: nil)
        }
        
        //This action resets everything to default
        let reset = UIAlertAction(title: "Reset", style: .default) { isAnArgumentLabelForUIAlertActionType in
            self.view.backgroundColor = UIColor.white
            self.share.setTitleColor(UIColor.blue, for: .normal)
            self.options.setTitleColor(UIColor.blue, for: .normal)
            self.dismiss(animated: true, completion: nil)
        }
        //Here we gather up all the UIAlertActions that we created and assign
        //them to the UIAlertConrtroller called menu
        menu.addAction(cancel)
        menu.addAction(Cool)
        menu.addAction(reset)
        //Lastly we present the AlertController
        self.present(menu, animated: true, completion: nil)
    }
}

//.......................................................................

//Examples of formatting the appearance of the Navigation controller.
class ChangingTheNavigationBarController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The title is unique from other elements in the Navigation Bar in that it
        //is formatted using attributed text properties, which takes a set of Key
        //value pairs to define.
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Other aspects of the Bar can be manipulated directly. This changes the 
        //color of the Back button & text that appears on the bar.
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Here we can control whether the navigation bar is visable or not 
        //when this ViewController shows up.
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //We can also say that we want to hide the Navigation bar this view
        //disappears.
        navigationController?.navigationBar.isHidden = true
    }
    
    
}





