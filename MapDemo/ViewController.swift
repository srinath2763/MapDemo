//
//  ViewController.swift
//  MapDemo
//
//  Created by IMCS2 on 2/23/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController,MKMapViewDelegate,UIPopoverPresentationControllerDelegate {
    var receivedTitle:String = ""

    var receivedSubtitle:String = ""
    var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var locations:[NSManagedObject] = []
    @IBOutlet weak var mapView: MKMapView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("view did load\(receivedString)")
//        // Do any additional setup after loading the view, typically from a nib.
//        let latitude:CLLocationDegrees = 32.840744
//        let longitude:CLLocationDegrees = -96.994970
//        let latitudeDelta:CLLocationDegrees = 0.01
//        let longitudeDelta:CLLocationDegrees = 0.01

        let span = MKCoordinateSpan( latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:32.840744,longitude:-96.994970), span: span)
        mapView.setRegion(region,animated:true)
//        let annotation = MKPointAnnotation()
//        annotation.title = annotationName
//        annotation.coordinate = coordinates
//        mapView.addAnnotation(annotation)
        let longPress = UILongPressGestureRecognizer(target: self, action:
            #selector (self.annotateMap(gestureRecognizer:)))
        longPress.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPress)
        
        
        /*
         Code for showing content
         */
        
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        //3
        do {
            locations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        // Add existing locations from local storage
        addLocations()
        
        display()
        
        
    }

   
    override func viewWillAppear(_ animated: Bool) {
        let annotation = MKPointAnnotation()
        annotation.title = receivedTitle
        annotation.subtitle = receivedSubtitle
        annotation.coordinate = coordinates
        self.mapView.addAnnotation(annotation)
        //Core
        save(latitude: coordinates.latitude, longitude: coordinates.longitude, title: receivedTitle, subtitle: receivedSubtitle)
    }
    
    @objc func annotateMap(gestureRecognizer: UIGestureRecognizer){
        
        self.performSegue(withIdentifier: "GetAnnotation", sender: nil)

        let touchPoint = gestureRecognizer.location(in: self.mapView)
        coordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        }
    
   
    func addLocations(){
        if locations.count<=1 {return}
        for i in 0...locations.count-1{
            let location_temp = locations[i]
            let latitude_temp = location_temp.value(forKey: "latitude") as! Double
            let longitude_temp = location_temp.value(forKey: "longitude") as! Double
            let coordinate_temp = CLLocationCoordinate2D(latitude: latitude_temp, longitude: longitude_temp)
            let annotation = MKPointAnnotation()
            annotation.title = location_temp.value(forKey: "title") as? String
            annotation.subtitle = location_temp.value(forKey: "subtitle") as? String
            annotation.coordinate = coordinate_temp
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func save(latitude: Double,longitude:Double,title:String,subtitle:String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Location",
                                       in: managedContext)!
        
        let location = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        location.setValue(latitude, forKeyPath: "latitude")
        location.setValue(longitude, forKeyPath: "longitude")
        location.setValue(title, forKeyPath: "title")
        location.setValue(subtitle, forKey: "subtitle")

       
        // 4
        do {
            try managedContext.save()
            locations.append(location)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func display() {
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        //3
        do {
            locations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    }


