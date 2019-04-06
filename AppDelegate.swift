//
//  AppDelegate.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 6.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController: DataController = DataController(modelName: "WakeUp")
    
    func checkSettingsUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "settings-data") {
            print("App has launched before")
        } else {
            let settings = Settings(snoozeInterval: 2, alarmStopStepCount: 20)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: settings, requiringSecureCoding: false)
                UserDefaults.standard.set(data, forKey: "settings-data")
                debugPrint("Saved...")
                UserDefaults.standard.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataController.load()
        FirebaseApp.configure()
        checkSettingsUserDefaults()
        
        // This Will Inject DataController Dependency
        let tabBarController = window?.rootViewController as! TabBarController
        tabBarController.selectedIndex = 0
        tabBarController.dataController = dataController
        guard let selectedViewController = tabBarController.selectedViewController as? SetAlarmViewController else { return true }
        selectedViewController.dataController = dataController
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "WakeUp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

