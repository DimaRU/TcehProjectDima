import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, NewEntryViewControllerDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableEntries: UITableView!
    
    //var entries = Entry.loadEntries()
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Декларируем, что этим классом мы будем обслуживать TableView внутри UIViewController
        tableEntries.dataSource = self
        let request = NSFetchRequest(entityName: "Entry")
        request.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false) ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataHelper.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        
        do {
            try fetchedResultsController.performFetch()
        } catch { }
    }
    
    // Вызывается на все сиги
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Через сигу находим класс, обслуживающий заполнение новой записи,
        // и закидываем себя в качестеве принимающего заполненную запись класса.
        
        if segue.identifier == "PresentNewEntry" {
            let newEntryController = segue.destinationViewController as! NewEntryViewController
            newEntryController.delegate = self
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Нужно сделать ячейку (EntryCell)
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
        
        let entry = fetchedResultsController.objectAtIndexPath(indexPath) as! Entry

        cell.categoryLabel.text = entry.category
        cell.amountLabel.text = String(format: "%.2f р.", entry.amount)
        
        return cell
    }
    
    func controllerDidChangeContent(controller:   NSFetchedResultsController) {
        tableEntries.reloadData()
    }
    

    func entryCreated(entry: Entry) {
//        entries.insert(entry, atIndex: 0)
        dismissViewControllerAnimated(true, completion: nil)
        
        // Обновляем экран
        tableEntries.reloadData()
        
        do {
            try CoreDataHelper.instance.context.save()
        } catch {
            print("Save failed")
        }
    }
}
