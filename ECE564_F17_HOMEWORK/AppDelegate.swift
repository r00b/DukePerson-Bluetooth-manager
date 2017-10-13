import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        FIRApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // this is the MINIMAL amount of code required to make an app run
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window!.backgroundColor = UIColor.gray
//        self.window!.makeKeyAndVisible()
//        // point window to VC file here
//        self.window!.rootViewController = BasicViewController()
        
        
        
        return true
        
    }
    
}
