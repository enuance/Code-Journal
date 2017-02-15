/*
Revized 2/14/17
Stephen Martinez's Code Journal Entry for working with Foundational Types
*/


import Foundation

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
