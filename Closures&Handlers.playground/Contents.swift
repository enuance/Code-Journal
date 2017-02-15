/*
 Created 2/14/17
 Stephen Martinez's Journal Entry for Declaring and Implementing closures and Handlers
 */

import UIKit

//Custom Completion Handler............................................................

//Comes in handy for use in Asyncronous calls so that view
//elements can be updated when completion has occured. Often Completion handlers are
//used in Methods whose primary purpose is to go off and change things around in it's
//environment or needs to check it's environment after a complex task has been
//accomplished.

//Here's an example of a variable to be changed by a function that returns Void
var aStringToChange = "Nothing Here"

//A declaration of a function that changes it's environment based on a parameter it
//recieves. The final parameter is our completion handler. This is so that when it
//is implemented it can be written with a "trailing closure" syntax. The completion
//parameter is typed with an escaping closure that can take parameters of its own if
//desired, but doesn't in this example.
func someMethodWithACompletionHandler(someParameter: String, _ completionHandler: @escaping ()-> Void){
    //The Closure has to have the prefix @escaping in order to enable it to escape the
    //bounds of the function and work properly as a completion handler.
    if someParameter.characters.count > 0{
        aStringToChange = "Something There"
    }
    //The handler is placed where you want it to be executed. In this instance we want it
    //to be executed when the function completes so we place it at the end.
    completionHandler()
    //This can be a bit more tricky when working with functions and methods that utilize
    //Asyncrony and swaps back to the main thread.
}

//When implementing the function you can exclude the completion handler from the paramters
//list and replace it with a trailing block of code to execute after the function has
//completed its task.
someMethodWithACompletionHandler(someParameter: "Time to change the string"){
    print("someMethodWithACompletionHandler(_:,_:) has completed it's execution!")
}