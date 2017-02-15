/*
 Created 2/8/17
 Stephen Martinez's Journal Entry for Protocols and Delegation
 */

import UIKit

///MARK: Creating and setting up a custom protocol: Delegate

/*
 This is especially Usefull when you need to pass data between
 View Controllers. For Instance if you're moving backwards through
 a navigation stack and the use of a Singleton or other globally
 accessed object is innappropriate.
 
 This example shows the case of navigating backwards through Navigation
 Stack, how to declare the protocol(also known as a delegate) and how
 implement them in the two VC's that you want communicating to eachother.
 */

//Enumeration for example only - Not vital to the Delegate patern.
enum Styles: Int{case Meme, School, Industrial, Typwriter, Notes, Handwritten, LoveLetter}
//....................................................................
//....................................................................


//First Declare your protocol: Make sure that you declare this outside
//of any class, Struct, or Enumeration. It has to be it's own standalone
//object
//Declaration of protocol.............................................
//....................................................................
protocol StyleSelectionDelegate: class{
    //Make sure that you subclass your protocol to the class Type. The
    //delegate patern requires that you protocol is "class bound" in order
    //for it to work!
    func didSelectStyle(_ description: Styles)
    //Declare the function, but do not implement it here!
}


//First View Controller for protocol to be implemented.................
//.....................................................................
class MemeViewController: UIViewController, StyleSelectionDelegate{
    // Property to set by the deegate method
    var myStyle: Styles!
    // Delegate Method declared here so that when the second VC is dismissed
    // The properties within the method can be updated with the data passed.
    func didSelectStyle(_ description: Styles) {
        myStyle = description
    }
    //Button invoked method to transition over to the Second View Controller
    @IBAction func memeStyleSelector(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeStylesVC = storyboard.instantiateViewController(withIdentifier: "StylesController")as! MemeStyleController
        memeStylesVC.delegate = self
        //Inform the Second View Controller of the delegation assignment
        self.navigationController!.pushViewController(memeStylesVC, animated: true)
        //Then push over to the Second View Controller
    }
    //If you're not using a Navigation Controller then you'd have to use a
    //different method of propogating data forward to the next VC, such as
    //a prepare for segue method or others.
}


//Second View Controller to get and send data backwards through Nav Stack.
//......................................................................
class MemeStyleController: UIViewController{
    //Declare the delegate property as optional and set to nil
    weak var delegate: StyleSelectionDelegate? = nil
    //Imperative that you use weak key word to declare delagate property
    //so that circular referencing doesn't creat memory leaks!
    
    //Button invoked method to grab data from user and send through delegate
    @IBAction func styleSelected (sender: UIButton){
        let styleForButton = Styles(rawValue: sender.tag)
        
        //Call the didSelectStyle Method and tell it wich style was selected.
        delegate?.didSelectStyle(styleForButton!)
        
        //Go back to first View Controller.
        navigationController!.popViewController(animated: true)
    }
}

//......................................................................
//......................................................................
//......................................................................


/// MARK: Setting up a textField Delegates

//Subscribe to the UITextFieldDelegate
class textFieldExampleController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var firstTextField: UITextField?
    @IBOutlet weak var secondTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField?.delegate = self
        secondTextField?.delegate = self
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Set up code for initial editing state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}








