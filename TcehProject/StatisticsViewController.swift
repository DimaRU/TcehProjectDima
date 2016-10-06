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

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let entries = Entry.loadEntries()
        
        let values = entries.reverse().map({ $0.amount })
        lineGraphView.values = values

    }

    @IBAction func selectGraphType(sender: UISegmentedControl) {
        
        lineGraphView.graphType = sender.selectedSegmentIndex
    }
}
