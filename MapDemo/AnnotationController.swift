//
//  AnnotationController.swift
//  MapDemo
//
//  Created by IMCS2 on 2/23/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit

class AnnotationController: UIViewController {
    
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var subTitle: UITextField!
    
    @IBAction func dismiss(_ sender: Any) {
        if let presenter = presentingViewController as? ViewController {
            presenter.receivedTitle = input.text!
             presenter.receivedSubtitle = subTitle.text!
            
           
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

