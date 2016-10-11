//
//  StatisticsViewController.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 26.09.16.
//  Copyright © 2016 Borovikov. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var lineGraphView: GraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(tapAction))
        
    }
    
    func tapAction() {
        
        UIGraphicsBeginImageContextWithOptions(lineGraphView.bounds.size, true, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        
        lineGraphView.drawViewHierarchyInRect(lineGraphView.bounds, afterScreenUpdates: false)
        
        // Снапшот экрана
        // let view = lineGraphView.snapshotViewAfterScreenUpdates(false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let entries = Entry.loadEntries()
        
        let values = entries.reverse().map({ $0.amount })
        lineGraphView.values = values
        
        lineGraphView.startAnimation(5)

    }

    @IBAction func selectGraphType(sender: UISegmentedControl) {
        
        lineGraphView.graphType = sender.selectedSegmentIndex
        lineGraphView.startAnimation(1.5)
    }
}
