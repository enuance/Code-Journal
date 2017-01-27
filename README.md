#Coding-Journal

##Stephen Martinez's Swift Coding Journal

So, basically this is my NoteBook for keeping a reference of concepts that I've learned or ideas that I've had and will
want to use again in the future. I keep finding myself going back to previous projects to see how I've implemented
things in the past and things can take a while to open a project, search for the right file and method or class and go
back to my current project. This way my usefull ideas are localized to one file and is easy to find.

```
/* 
Often Times I'll create classes in order to provide a context for the idea
*/

//How to assign a delegate

class MyExampleClass: UIViewController, SomeDelegatePrototcol{

@IBOutlet weak var somePropertyContainingADelegate: AType!

    override func viewDidLoad(){
        //Make sure to always call Super Class Method to ensure consistency if/when Super is changed.
        super.viewDidLoad()
        somePropertyContainingADelegate.delegate = self
    }

}

```

I'll be updating this as I go along and learn. I hope you find this useful.
