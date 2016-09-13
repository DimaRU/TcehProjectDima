import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, NewEntryViewControllerDelegate {

    @IBOutlet weak var tableEntries: UITableView!
    
    //var entries = [Entry]()
    var entries = Entry.loadEntries()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Декларируем, что этим классом мы будем обслуживать TableView внутри UIViewController
        tableEntries.dataSource = self
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
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Нужно сделать ячейку (EntryCell)
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
        
        cell.categoryLabel.text = entries[indexPath.row].category
        cell.amountLabel.text = String(format: "%.2f р.", entries[indexPath.row].amount)
        
        return cell
    }

    func entryCreated(entry: Entry) {
        entries.insert(entry, atIndex: 0)
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
