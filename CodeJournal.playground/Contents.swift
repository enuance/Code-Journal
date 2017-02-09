/*
Stephen Martinez
This is my coding journal where I can put thoughts, ideas, 
notes, and concepts that I'd like to refer back to for future 
use in programs that I write.
*/


import UIKit

///MARK: STRINGS AND THEIR MANIPULATION

///MARK: If you'd like to join an array of strings together with
//a next-line in between each.
let a1 = ["Hello,","My","name","is","Stephen."].joined(separator: "\n")
//print(a1)

///MARK: My Method that slices words by index # and extends the
//String Struct.
extension String{
    func slice(from: Int, _ to: Int? = nil) -> String{
        //A check for error conditions regaurdless of nil arguments
        if self.characters.count == 0 || from < 0 || from > self.characters.count - 1{return ""}
        //A check that nil isn't present and more error conditions
        if let to = to{
           if to >= self.characters.count{return ""}
           else if to < 0{return ""}
           else if from > to{return ""}
           else{
            //Setting index points and returning the sliced string
                let start = self.index(self.startIndex, offsetBy: from)
                let end = self.index(self.startIndex, offsetBy: to)
                return self[start...end]
            }
        }else{
            //Setting index points in the condition that the "to" point
            //is set to nil and then returning the sliced string
            let start = self.index(self.startIndex, offsetBy: from)
            let end = self.index(self.endIndex, offsetBy: -1)
            return self[start...end]
        }
    }
}

var a2 = "A String to Slice."
let a3 = a2.slice(from: 0, 7)
//print(a2)
//print(a3)

///MARK: Inserting elements in a String
var a4 = a3.replacingOccurrences(of: "String", with: "apple")
a4 = a4.replacingOccurrences(of: "A", with: "An")
a4 += " to slice!"
//print(a4)

///MARK: Using Swift String Indexing Methods
let start = a4.index(a4.startIndex, offsetBy: 3)
let end = a4.index(a4.startIndex, offsetBy: 7)
let a5 = a4[start...end]

///MARK: Uppercase, lowercase, and insensitivity for Strings
a5.uppercased()
a5.lowercased()
a5.folding(options: .diacriticInsensitive, locale: .current)
// diacritic are the small tics and marks such as "ñ" and "é"
// the folding option with this insensitivity returns a String
// without those marks

(a5.compare("ApPlE", options: .caseInsensitive, range: nil, locale: .current) == ComparisonResult.orderedSame)
//You can compare two strings with eachother to see if they are
//the same and disregard case or diacritic markings.

let a6 = "ApPlE"
a6.lowercased().contains(a5)
//You can achieve the same result by using the contains method
//wich returns a Boolean value

let aWord = "Hello"
print(!aWord.characters.contains(" "))


///MARK: If using if or Switch Statements you can use the let/where condition.

func deadlineCheck (_ aDeadline: Int, _ CurrentDay: Int)-> String{
    switch aDeadline - CurrentDay{
    case let x where x <= 0:
        //The let keyword sets the point of reference and the where keyword sets
        //the condition that acts upon that point.
        return "today"
    case 1...7:
        return "upcoming"
    case let z where z > 7:
        return "later"
    default:
        return "Wrong input type: Must be integer!"
    }
}


///MARK: Segues & Navigation Pushes - Various methods

//Push Navigation with a Navigation Controller done programatically.....
class SomeController: UIViewController{
    //A property to pass through the Navagation.
    var someProperty: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the property value
        someProperty = "Valuable Data to Pass 😀"
    }
    
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

class SomeClass: UIViewController{
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

