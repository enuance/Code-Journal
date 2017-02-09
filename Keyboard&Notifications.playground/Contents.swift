/*
 Created 2/8/17
 Stephen Martinez's Journal Entry for Keyboards and Notifications
 */

import UIKit

class KeyBoardExampleController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var topTextEntry: UITextField!
    @IBOutlet weak var bottomTextEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomTextEntry.delegate = self
        //Calling a helper method that sets up NSNotifications for our Keyboard
        subscribeToKeyboardNotifications()
    }
    
    //Keyboard Management Section.............................................................
    func keyboardWillShow(_ notification: Notification){
        //Only move Main View with Keyboard if the bottom text field is in use!
        if bottomTextEntry.isEditing{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                view.frame.origin.y = 0 - keyboardSize.height
            }
        }
    }
    
    //Put the Main View back in it's place when keyboard hides.
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {view.frame.origin.y = 0}
    }
    
    func subscribeToKeyboardNotifications(){
        //Sets up the observer and the method that will be called when the Keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //Sets up the observer and the method that will be called when the keyboard disappears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}





