# HW7

## Robert Steilberg, Ritwik Heda, Harshil Garg, Teddy Franceschi


#### Extensions

In addition to the project specifications, we added the following features:

* Added a _real_ progress bar that quantifies the progress of the peripheral sending process
* Added a loading spinner to indicate that the central is actively receiving/looking for a peripheral
* Successfully sent and received data with 5 teams

#### Build Instructions and Notes

*IMPORTANT DIRECTIONS THAT MUST BE FOLLOWED TO TEST FUNCTIONALITY*:

1. You **MAY NEED TO** add a unique identifier to the Bundle Identifier for the signing process to work correctly. If the build fails because of a bad certificate, do the following: In project settings under General -> Identity, the current Bundle Identifier is `edu.duke.TheGargsHW7.564`; all you need to do is change this to `edu.duke.TheGargsHW7.yourNetID` or something else so that it will work with your development profile.

2. Deploy the project to the **first** iPod Touch (ensure that its Bluetooth is on)

3. Under the `Data` folder, in `DukePeopleDatabase.swift`, change line 21 to `static private var dbName = "BlueTooth"`

4. Deploy the project to the **second** iPod Touch (ensure that its Bluetooth is on)

5. You can now test Bluetooth send/receive between the two devices by hitting the "Receive" bar button on the TableView of the central and the "Send" button in the DukePerson detail page of the peripheral. It doesn't matter which button is pressed first.

The reason why step 3 is necessary is because we use Firebase. Step 3 tells the second iPod Touch to use a different database. If both of the iPod Touches you are testing on are hooked up to the same database, they will always have identical data, thus rendering Bluetooth sending pointless (since we automatically ignore duplicate entries received via Bluetooth). **ADDITIONALLY**, you must ensure that the image has been downloaded from Firebase and rendered on screen before attempting the Bluetooth transfer.

Note: If you are transferring a DukePerson with an image, it may take up to a minute to transfer, due to the process associated with converting an image to a String and transferring that string (which is often quite long). The loading bar will indicate progress.

Please let us know if you have any questions or problems.

 **Other important notes**

The workspace must be opened in Xcode via the "ECE564_F17_HOMEWORK.xcworkspace" file, NOT the "TheGargsHW.xcodeproj" file. If there is a "TheGargsHW.xcworkspace" file, do not open that either.

If there is an issue, it is likely because of our Pod-based file architecture. Running `pod install` should not be necessary. Please let us know if you have any issues compiling and running the app.

The device on which the app is run MUST be connected to the internet for the Firebase server to connect properly.

There are no buildtime or runtime warnings/errors when running on the iPod Touch, but when running _locally_, you may get a runtime warning about a UI API being called from a background thread. This is an async problem inherent of using Firebase in a non-production environment.


#### Adding Animation to a DukePerson (from HW6)

1. Animation must subclass UIViewController; if it does, add it to the project
2. Add `firstname` and instantiation of the animation view controller in the DetailViewController (the variable you need to insert it into is the `animations` dictionary)
3. Add the following code to the animation view controller you are adding:

```
var escapeButton =  UIButton()

func addEscape(){
escapeButton.frame = CGRect(x: 270, y: 23, width: 40, height: 40)
escapeButton.setImage(#imageLiteral(resourceName: "x"), for: .normal)
escapeButton.addTarget(self, action: #selector(escapeAction), for: .touchUpInside)
self.view.addSubview(escapeButton)
self.view.bringSubview(toFront: escapeButton)
}

@objc func escapeAction(_ sender: Any) {
let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
self.present(nextViewController, animated:true, completion:nil)
}
```

4. Ensure that all animation code is in `viewDidAppear` and add `addEscape()` at the end of `viewDidAppear`

5. Enjoy a Garg-tastic animation!


<!--
HW 5

Additional Features

Due to pods added for Firebase project must be opened from the workspace file and not the project file; otherwise, an error will occur

To use camera functionality unlock information view and press takepicture if using the camera functionality is available the app will give the user choice between taking phot from camera or from photos library; otherwise, it will be opened from the photos library. PLEASE TRY ON BOTH SIMULATOR and ITOUCH.

Used Firebase to persist data. Please use WITH INTERNET CONNECTED! Had to use asynchronous programming.

Added additional architecture to DukeTableDatabase to manage database operations.

Am able to upload as well as dowload images from web so they can be shown on the app used Firebase Storage to host the images

Added and persisted new company field

Added attributed text that tells the user what needs to be fixed in order for the DukePerson to be saved.

On pressing "save" button there is a delay for the DukeTable to come back up because the image is being uploaded to firebase and this cannot be done asynchronously because if it is then the new image on the DukeTable is outdated.




HW 4

How to get to animation. If Ritwik is clicked in the tableView then there will be a button on the bottom of the information view called animation. Pressing that button will take you to the animation. Pressing the x button in the corner will take you back to the informationView. The background for the animation (hills, ground, skills)

Additional Features added

-The animation is fairly complex as there are multiple moving items and a custom view in the background.
- there is attributed text for the gameover at the end
- there is music that plays along with the animation and that starts and stops with its associated view controller
- the sounds in the music match the actions going on the animation (mario shrink, mario jump, mario eat mushroom, fireball, mario die)
- the editing mode is enable via a lock/unlock button now and the text changes with that as well

Animation pictures from

http://www.iconarchive.com/show/super-mario-icons-by-ph03nyx.html


<div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>


HW 3

How to Navigate the app

The initial screen shows table cells of DukePeople separated by seperator cells that indicate their role. Clicking in the searchBar will allow to search the Duke People by name. You can search by first name by putting in the first name (i.e. Ric) and then pressing the search button in the keyboard. You can search by first and last name by putting in the name with a space separating the first and last name (i.e. Ric Telford) and then hitting the search button. If you want to show all items in the tableView make sure to press the searchBar and then hit the cancel button next to it. If you click on the addButton above the search Bar you will be naviagted to a screen where you can enter fields as well as add a picture from the camera. If you are entering information in the field and the keyboard covers the field simply scroll down on the area outside the keyboard until the textfield you are editing shows up (extra space at the bottom of this page for that purpose). Clicking the cancel button will simply take you back to the first page and clicking the save button will check the entries in all the fields and if they are correct it will save the new dukePerson and add it to the TableView if there is something wrong in the fields it will let you know.Tapping on a dukePerson in the TableView will do the same thing except instead of adding a newPerson you would be editing an existing person.

Additional Features

used segmented control for the user to pick different enum values (gender/role) in edit/add page

added searchBar and search functionality

added searchBar cancel Button

custom cells UI has custom fonts and better layout than HW description

custom dukePerson cell's content have been encased in another view in order to add rounded corners

add ability to take pictures

added scrollview on edit/create page to accomadate more items

all images are rounded by modifying the layer's corner Radius in the storyboard file

Images from

<div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>


HW 2

How to Navigate the app

The initial screen can only be used for searching and going through dukePersons from DukePeople. Use the pickerView to select language or a name you would like to look up by. The app opens up with all dukePersons in the tableview near the bottom and clicking on the names in the tableview will give u their description. Add text in the form specified by the placeholder text and upon clicking the search button the names in the tableview will be filtered by either that name (if name is elected in pickerView) or by language filtered dukePerson(s) must know one of the specified languages). Pressing the add button will open a popUp and give u fields to enter if u would wish to add a new person to the list. (In order to find the new person added to the list you must look up their name or language). In order for the addButton to be clicked on the popUp page all of the field must be entered in the way specified by their respective placeholder texts.

Additions added

Features
- unique UI (I knew we couldn't search by all fields and also that the default UI for this assignment didn't have the ability to find all the people that may have the same name or know the same language). I wanted to create a delineation for the user between searching for fields and adding people an thats why i separated it into a main screen and a popUp.  
- pickerView for switching between searching by gender and by language
- escape button on popUp so people don't get stuck on the popUp
- icons for search, escape, and add buttons
- scrollable table view for looking through multiple filtered dukePerson(s)
- hard to see on white but a blur field behind the popUp and a shadow behind the popUp to make it obvious to the user that they have clicked on a popUp


CodeDesign
- made global positioning variables with dynamic getters that help them be reused to create several UIelements (i.e. y1 can be used to place several UI elements -- as each time its called it moves down the page so the developer only has to specify the increment value in the getter rather than typing new new numbers for every y axis placement
- made a makeFields() method that dynamically adds a field (TextView and UITextField pair) to any view specified (popUp or superview), names them and displays them (helps clean up and organize the code)
- made a textList variable that holds all the textFields so they can just be looped through in order to clear them of their text when the popUp is closed
- organized the code into functions to help organize the code and grouped functions and variables dealing with similar things in the same place (easier to read and grade 🙂 )


Citations

Icon png citations

<div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>







HW 1

Requirements

You must include 4 of the following - array, dictionary, set, class, function, closure expression, enum, struct

Array - A list of qualified developers is returned as an array of string ln.183

Dictionary - A skill dictionary is used in order to store a directory of language: to DukePeople who are proficient in them ln.152

Set - A set is used to eliminate duplicates from the list of names of DukePeople that is returned by findDevelopers ln.174

Class - DukePerson was class used in this program ln.67

function - the function numberOfNamesThatStartWith was written to find the number of names of DukePerson(s) in DukePeople whose names start with a specified character ln.186


You must include 4 different types, such as string, character, int, double, bool, float

string - degree is stored as a string ln.80

character - numberOfNamesThatStartWith() takes in a character as a parameter ln.186

int - numberOfNamesThatStartWith() returns a int ln.186

bool - a bool, 'val', is used to test whether the dictionary contains a null value for a language ln.155

You must include 4 different control flows, such as for/in, while, repeat/while, if/else, switch/case

for/in - was used in the setter of skillsDictionary to iterate over each language in a dukePerson's languages ln.156

while - a while loop was used to iterate through DukePerson(s) in dukePeople ln.189

if/else - was used to construct a gendered pronoun in the printGender function ln.101

switch case - was used in the printDegree() function to generate different strings based on the degree one holds ln.129


Extra functions and Improvements added

Many functions were added to better break up the production of the output string and make the code cleaner and more concise, such as printLanguages, printGender, printHobbies,  & printDegree ln.86-137

A skillDictionary was added that maps languages to a list of people who know them. Additionally, skillDictionary has a customized getter that allows the dictionary to be recreated every time it is used. This is done in order to ensure that skillDictionary always has the latest changes on information from DukePeople (the array of DukePerson(s) on which the dictionary is based) ln.152

A findDevelopers function was added that takes in an array of strings (languages) and returns an array of names of developers who are proficient in at least one of the languages in the list ln.173

A numberOfNamesThatStartWith function was added that allows a user to query the number of dukePeople whose names start with a specific character ln.186 -->
