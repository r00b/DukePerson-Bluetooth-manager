//
//  DetailViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 9/21/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let blastoise = FIRStorage.storage().reference().child("Blastoise.jpeg")
    let storageRef = FIRStorage.storage().reference()
    var animation: UIViewController!
    
   
    @IBOutlet weak var animationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.toggleKeyboard()
        firstNameField.isEnabled = false
        lastNameField.isEnabled = false
        homeField.isEnabled = false
        genderSegmentedControl.isEnabled = false
        roleSegmentedControl.isEnabled = false
        languagesField.isEnabled = false
        hobbiesField.isEnabled = false
        roleField.isEnabled = false
        teamField.isEnabled = false
        companyField.isEnabled = false
        pictureButton.isEnabled = false
        lockButton.imageView!.image = #imageLiteral(resourceName: "LockClosed")
        
        var animations = [
            "Ritwik": RitwikAnimationViewController(),
            "Robert": HobbySCUBAViewController(),
            "Teddy": TeddyViewController(),
            "Harshil": HarshilAnimationViewController()
        ]
        if(Data.selectedPerson != nil){
            if let animationController = animations[(Data.selectedPerson?.getFirstName())!]{
                animation = animationController
            }else{
                animationButton.alpha = 0
            }
        }else{
            animationButton.alpha = 0
        }
        
        if(Data.selectedPerson != nil){
            loadFields(dukePerson: Data.selectedPerson!)
        }else{
            unlock(self.view)
            lockButton.alpha = 0.0
        }
        
//        blastoise.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//            if (error != nil) {
//                print(error)
//            } else {
//                self.profilePic.image = UIImage(data: data!)
//            }
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //POPUP
    
    var addButton = UIButton()
    
    var addButton2 = UIButton()
    
    var clearButton = UIButton()
    
    var imageButton = UIButton()
    
    var cameraButton = UIButton()
    
    var pictureSourceLabel = UILabel()
    
    var photosLabel = UILabel()
    
    var cameraLabel = UILabel()
    
    var popUp : UIView!
    
    var blurEffectView: UIVisualEffectView!
    
    @IBAction func animationAction(_ sender: Any) {
        
        let modalStyle = UIModalTransitionStyle.flipHorizontal
        let svc = animation
        svc?.modalTransitionStyle = modalStyle
        present(svc!, animated: true, completion: nil)
    }
    
    func createPopUp(){
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        let popUpFrame = CGRect(x: self.view.frame.width/2 , y: self.view.frame.height/2 , width: self.view.frame.width/1.5, height: self.view.frame.height/3)
        popUp = UIView(frame: popUpFrame)
        popUp.center = CGPoint(x: self.view.center.x , y: self.view.center.y - 60 )
        popUp.backgroundColor = .white
        popUp.layer.cornerRadius = 10
        popUp.layer.shadowRadius = 10.0;
        popUp.layer.shadowOpacity = 0.5;
        self.view.addSubview(popUp)
        
        clearButton.center = CGPoint(x: Int(popUp.frame.maxX)-30, y: Int(popUp.frame.minY)+30)
        clearButton.bounds = CGRect(x: 20, y: 20, width: 20, height: 20)
        clearButton.setImage(#imageLiteral(resourceName: "ThinDelete"), for: UIControlState.normal)
        clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        clearButton.backgroundColor = .clear
        self.view.addSubview(clearButton)
        
        
        imageButton.bounds = CGRect(x: 20, y: 20, width: 50, height: 50)
        imageButton.center = CGPoint(x: Int(popUp.center.x)-50, y: Int(popUp.center.y)+40)
        imageButton.setImage(#imageLiteral(resourceName: "Picture"), for: UIControlState.normal)
        imageButton.addTarget(self, action: #selector(photosAction), for: .touchUpInside)
        imageButton.backgroundColor = .clear
        self.view.addSubview(imageButton)
        
        cameraButton.bounds = CGRect(x: 20, y: 20, width: 50, height: 50)
        cameraButton.center = CGPoint(x: Int(popUp.center.x)+50, y: Int(popUp.center.y)+40)
        cameraButton.setImage(#imageLiteral(resourceName: "Camera"), for: UIControlState.normal)
        cameraButton.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)
        cameraButton.backgroundColor = .clear
        self.view.addSubview(cameraButton)
        
        let maxSize = CGSize(width: 100, height: 20)
        
        
        pictureSourceLabel.text = "Choose Picture Source"
        let pictureSourceSize = pictureSourceLabel.sizeThatFits(maxSize)
        pictureSourceLabel.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: pictureSourceSize)
        pictureSourceLabel.textColor = .blue
        pictureSourceLabel.center = CGPoint(x: Int(popUp.center.x), y: Int(popUp.center.y) - 35)
        self.view.addSubview(pictureSourceLabel)
        

        photosLabel.text = "Photos"
        let photosSize = photosLabel.sizeThatFits(maxSize)
        photosLabel.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: photosSize)
        photosLabel.textColor = .blue
        photosLabel.center = CGPoint(x: Int(imageButton.center.x), y: Int(imageButton.center.y) + 35)
        self.view.addSubview(photosLabel)
        

        cameraLabel.text = "Camera"
        let cameraSize = cameraLabel.sizeThatFits(maxSize)
        cameraLabel.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: cameraSize)
        cameraLabel.textColor = .blue
        cameraLabel.center = CGPoint(x: Int(cameraButton.center.x), y: Int(cameraButton.center.y) + 35)
        self.view.addSubview(cameraLabel)
        
        print("Popcreated")
        

        
    }
    @objc func photosAction(sender: UIButton!){
        clear()
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @objc func cameraAction(sender: UIButton!){
        clear()
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }

    
    
    @objc func clearAction(sender: UIButton!){
        print("clear() has been called")
        clear()
    }
    
    func clear(){
        print("clear() has been called")
        popUp.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        clearButton.removeFromSuperview()
        imageButton.removeFromSuperview()
        cameraButton.removeFromSuperview()
        photosLabel.removeFromSuperview()
        cameraLabel.removeFromSuperview()
        pictureSourceLabel.removeFromSuperview()
    }
    
    
    func addAction2(sender: UIButton!){

    }
    
    
    

    
    // TextFieldProperties
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    
    @IBOutlet weak var teamField: UITextField!
    
    @IBOutlet weak var companyField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var homeField: UITextField!
    
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var languagesField: UITextField!
    
    
    @IBOutlet weak var hobbiesField: UITextField!
    @IBOutlet weak var roleField: UITextField!
    
    
    let genderArray = [Gender.Male, Gender.Female]
    
    let roleArray = [DukeRole.Student, DukeRole.Professor, DukeRole.TA]
    
    @IBOutlet weak var firstNameField: UITextField!
    
    
    
    
    //Picture
    
    @IBOutlet weak var pictureButton: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBAction func addPicture(_ sender: Any) {
        
//        let picker = UIImagePickerController()
//        picker.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        picker.sourceType = .camera
//        present(picker, animated: true, completion: nil)
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            createPopUp()
        }else{
            let picker = UIImagePickerController()
            picker.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("I'm in the right place")
            profilePic.contentMode = .scaleAspectFill
            profilePic.image = pickedImage
            profilePic.layer.cornerRadius = 60
            profilePic.layer.borderWidth = 2
            profilePic.layer.borderColor = UIColor.gray.cgColor
            profilePic.layer.masksToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // Cancel and Save
    
    @IBAction func cancelAction(_ sender: Any) {
        performSegue(withIdentifier: "DetailTableSegue", sender: nil)
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if(Data.selectedPerson != nil){
            if(checkFields(dukePerson: Data.selectedPerson)){
                
                addExistingImageSegue(dukePerson: Data.selectedPerson!)
                //performSegue(withIdentifier: "DetailTableSegue", sender: nil)
            }
        }else{
            let newPerson = DukePerson(firstName: "Default first name", lastName: "default last name", whereFrom: "default location", gender: .Female, hobbies: ["nothing"], role: .Student, languages: ["nothing"], degree: "nothing")
            if(checkFields(dukePerson: newPerson)){
                Data.dukePeople.append(newPerson)
                addNewImageSegue(dukePerson: newPerson)
                //performSegue(withIdentifier: "DetailTableSegue", sender: nil)
            }
        }
        
    }
    
    func addNewImageSegue(dukePerson: DukePerson){
        let imageRef = storageRef.child("\(dukePerson.hashValue).jpeg")
        if let uploadData = UIImageJPEGRepresentation(profilePic.image!, 0.5){
            imageRef.put(uploadData, metadata: nil, completion:
                { (metadata, error) in
                    if(error != nil){
                        print(error!)
                        return
                    }
                    print("a")
                    DukePeopleDatabase.setFirebaseStatus(dukePeople: Data.dukePeople)
                    self.performSegue(withIdentifier: "DetailTableSegue", sender: nil)
                    print(metadata?.downloadURL()! as Any)
            })
        }
        
    }
    
    func addExistingImageSegue(dukePerson: DukePerson){
       
        let imageRef = storageRef.child("\(dukePerson.hashValue).jpeg")
        if let uploadData = UIImageJPEGRepresentation(profilePic.image!, 0.5){
            imageRef.put(uploadData, metadata: nil, completion:
                { (metadata, error) in
                    if(error != nil){
                        print(error!)
                        return
                    }
                    print("a")
                    DukePeopleDatabase.setFirebaseStatus(dukePeople: Data.dukePeople)
                    self.performSegue(withIdentifier: "DetailTableSegue", sender: nil)
                    print(metadata?.downloadURL()! as Any)
            })
        }
        
    }
    
    // checkFields
    
    func checkFields(dukePerson: DukePerson?) -> Bool{
        let firstNameCheck = checkFirstName(dukePerson: dukePerson)
        let secondNameCheck = checkLastName(dukePerson: dukePerson)
        let homeCheck = checkHome(dukePerson: dukePerson)
        let languageCheck = checkLanguages(dukePerson: dukePerson)
        let hobbiesCheck = checkHobbies(dukePerson: dukePerson)
        let roleCheck = checkRole(dukePerson: dukePerson)
        let teamCheck = checkTeam(dukePerson: dukePerson)
        let companyCheck = checkCompany(dukePerson: dukePerson)
        dukePerson?.gender = genderArray[genderSegmentedControl.selectedSegmentIndex]
        dukePerson?.role = roleArray[roleSegmentedControl.selectedSegmentIndex]
        //dukePerson?.image = profilePic.image
        return firstNameCheck && secondNameCheck && homeCheck && languageCheck && hobbiesCheck && roleCheck && teamCheck && companyCheck
    }
    
    func checkFirstName(dukePerson: DukePerson?) -> Bool{
        if firstNameField.text?.trimmingCharacters(in: [" "]) != nil && firstNameField.text?.trimmingCharacters(in: [" "]) != ""{
            dukePerson?.firstName = firstNameField.text!
            return true
        }else{
            firstNameField.text = ""
            firstNameField.attributedPlaceholder = NSAttributedString(string: "Please enter a valid First Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return false
        }
        
    }
    
    func checkLastName(dukePerson: DukePerson?) -> Bool{
        if lastNameField.text?.trimmingCharacters(in: [" "]) != nil && lastNameField.text?.trimmingCharacters(in: [" "]) != ""{
            dukePerson?.lastName = lastNameField.text!
            return true
        }else{
            lastNameField.text = ""
            lastNameField.attributedPlaceholder = NSAttributedString(string: "Please enter a valid Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return false
        }
        
    }
    
    func checkHome(dukePerson: DukePerson?) -> Bool{
        if homeField.text?.trimmingCharacters(in: [" "]) != nil && homeField.text?.trimmingCharacters(in: [" "]) != ""{
            dukePerson?.whereFrom = homeField.text!
            return true
        }else{
            homeField.text = ""
            homeField.attributedPlaceholder = NSAttributedString(string: "Please enter a valid location", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return false
        }
        
    }
    
    func checkLanguages(dukePerson: DukePerson?) -> Bool{
        if languagesField.text?.trimmingCharacters(in: [" "]) != nil && (languagesField.text?.components(separatedBy: ",").count)! <= 3{
            dukePerson?.languages = (languagesField.text?.components(separatedBy: ","))!
            return true
        }else{
            languagesField.text = ""
            languagesField.attributedPlaceholder = NSAttributedString(string: "Please enter up to three languages", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return false
        }
        
    }
    
    func checkHobbies(dukePerson: DukePerson?) -> Bool{
        if hobbiesField.text?.trimmingCharacters(in: [" "]) != nil && hobbiesField.text?.trimmingCharacters(in: [" "]) != ""{
            dukePerson?.hobbies = (hobbiesField.text?.components(separatedBy: ","))!
            print("updated")
            return true
        }else{
            hobbiesField.text = ""
            hobbiesField.attributedPlaceholder = NSAttributedString(string: "Please enter hobbies", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return false
        }
    }
    
    
    func checkRole(dukePerson: DukePerson?) -> Bool{
        if roleField.text?.trimmingCharacters(in: [" "]) != nil && roleField.text?.trimmingCharacters(in: [" "]) != ""{
            dukePerson?.degree = roleField.text!
            return true
        }else{
            roleField.text = ""
            roleField.attributedPlaceholder = NSAttributedString(string: "Please enter a degree", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return false
        }
    }
    
    func checkTeam(dukePerson: DukePerson?) -> Bool{
        if teamField.text?.trimmingCharacters(in: [" "]) != nil && teamField.text?.trimmingCharacters(in: [" "]) != ""{
            dukePerson?.team = teamField.text!.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
            return true
        }else{
            dukePerson?.team = nil
            return true
        }
        
    }
    
    func checkCompany(dukePerson: DukePerson?) -> Bool{
        if companyField.text?.trimmingCharacters(in: [" "]) != nil && companyField.text?.trimmingCharacters(in: [" "]) != ""{
            dukePerson?.company = companyField.text!
            return true
        }else{
            dukePerson?.company = nil
            return true
        }
        
    }
    
    
    func loadFields(dukePerson: DukePerson){
        firstNameField.text = dukePerson.firstName
        lastNameField.text = dukePerson.lastName
        homeField.text = dukePerson.getHome()
        if(dukePerson.getGender() == "Male"){
            genderSegmentedControl.selectedSegmentIndex = 0
        }else{
            genderSegmentedControl.selectedSegmentIndex = 1
        }
        if(dukePerson.role == .Student){
            roleSegmentedControl.selectedSegmentIndex = 0
        }else if(dukePerson.role == .Professor){
            roleSegmentedControl.selectedSegmentIndex = 1
        }else{
            roleSegmentedControl.selectedSegmentIndex = 2
        }
        languagesField.text = dukePerson.getLanguages()
        hobbiesField.text = dukePerson.getHobbies()
        roleField.text = dukePerson.getDegree()
        profilePic.image = #imageLiteral(resourceName: "Avatar")
        //DukePeopleDatabase.addImage(dukePerson: dukePerson)
        getImage(dukePerson: dukePerson)
        if(dukePerson.company != nil){
            companyField.text = dukePerson.company
        }
        
        if(dukePerson.team != nil){
            teamField.text = dukePerson.team
        }
        
    }
    
    func getImage(dukePerson: DukePerson){
        let imageRef = storageRef.child("\(dukePerson.hashValue).jpeg")
        imageRef.data(withMaxSize: 1 * 1024 * 1024 * 10) { (data, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                self.profilePic.image = UIImage(data: data!)
                //self.profilePic.image = dukePerson.image!
                self.profilePic.contentMode = .scaleAspectFill
                self.profilePic.layer.cornerRadius = 60
                self.profilePic.layer.borderWidth = 2
                self.profilePic.layer.borderColor = UIColor.gray.cgColor
                self.profilePic.layer.masksToBounds = true
            }
        }
        print("b")
    }
    

    
    
    //Unlock
    
    
    @IBAction func unlock(_ sender: Any) {
        if(lockButton.imageView!.image == #imageLiteral(resourceName: "LockClosed")){
            firstNameField.isEnabled = true
            lastNameField.isEnabled = true
            homeField.isEnabled = true
            genderSegmentedControl.isEnabled = true
            roleSegmentedControl.isEnabled = true
            languagesField.isEnabled = true
            hobbiesField.isEnabled = true
            roleField.isEnabled = true
            teamField.isEnabled = true
            companyField.isEnabled = true
            pictureButton.isEnabled = true
            lockButton.setImage(#imageLiteral(resourceName: "LockOpen"), for: .normal)
            pictureButton.setTitle("Take Picture +", for: .normal)
        }else{
            firstNameField.isEnabled = false
            lastNameField.isEnabled = false
            homeField.isEnabled = false
            genderSegmentedControl.isEnabled = false
            roleSegmentedControl.isEnabled = false
            languagesField.isEnabled = false
            hobbiesField.isEnabled = false
            roleField.isEnabled = false
            teamField.isEnabled = false
            companyField.isEnabled = false
            pictureButton.isEnabled = false
            lockButton.setImage(#imageLiteral(resourceName: "LockClosed"), for: .normal)
            pictureButton.setTitle("Click on lock to edit", for: .normal)
        }
        
        
    }
    @IBOutlet weak var lockButton: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
