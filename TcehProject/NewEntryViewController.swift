import UIKit

// Выхывающий этот класс должен обслуживать создание записи
protocol NewEntryViewControllerDelegate {
    func entryCreated(entry: Entry)
}


class NewEntryViewController: UIViewController, CategoriesViewControllerDelegate, VenuesViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var buttonCategories: UIButton!
    @IBOutlet weak var buttonVenues: UIButton!
    
    var delegate: NewEntryViewControllerDelegate?
    
    var selectedVenue: Venue?
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldAmount.text = ""
        textFieldAmount.placeholder = "0"
        textFieldAmount.delegate = self         // Check abount field consistency
        
        // Set Currency label text
        currencyLabel.text = "руб."
        
        let offsetFromRight = currencyLabel.intrinsicContentSize().width + 8  // Currency label ident from right border
        
        textFieldAmount.rightView = UIView(frame: CGRect(x: 0, y: 0, width: offsetFromRight, height: 30))
        textFieldAmount.rightViewMode = .Always
    }
    
    //вызывается перед самым показом экрана
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //открыть клавиатуру
        textFieldAmount.becomeFirstResponder()
    }
    


    //обработка нажатия на кнопку Done
    @IBAction func tapDone(sender: AnyObject) {
        if let text = textFieldAmount.text {
            if let amount = Double(text) {
                print("you entered \(amount)")
                //перестань быть активным элементом
                textFieldAmount.resignFirstResponder()
                
                if let venue = selectedVenue, category = selectedCategory {
                    
                    let concurrent = CoreDataHelper.instance.concurrent
                    concurrent.performBlock {
                        
                        concurrent.insertObject(venue)
                        let entry = Entry(amount: amount, venue: venue, category: category, context: concurrent)
                        CoreDataHelper.instance.saveConcurrent()
                        
                        CoreDataHelper.instance.context.performBlock {
                            let mainEntry = CoreDataHelper.instance.context.objectWithID(entry.objectID) as! Entry
                            self.delegate?.entryCreated(mainEntry)
                        }
                    }

                } else {
                    // Alert - Please select category and venue
                    let alert = UIAlertController(title: nil, message: "Please select category and venue", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            
            } else {
                // Alert - Please enter amount
                let alert = UIAlertController(title: nil, message: "Please enter amount", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    
    @IBAction func tapClose(sender: AnyObject) {
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Делаем стандартное действие
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "PresentCategories" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let categoriesController = navigationController.viewControllers[0] as! CategoriesViewController
            
            categoriesController.delegate = self
            
        }

        if segue.identifier == "PresentVenues" {
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let venuesController = navigationController.viewControllers[0] as! VenuesViewController
            
            venuesController.delegate = self
            
        }
    }

    func categorySelected(category: String) {
        
        dismissViewControllerAnimated(true, completion: nil)
        buttonCategories.setTitle(category, forState: .Normal)
        
        selectedCategory = category
    }
    
    func venueSelected(venue: Venue) {

        dismissViewControllerAnimated(true, completion: nil)
        buttonVenues.setTitle(venue.name, forState: .Normal)
        
        selectedVenue = venue
    }
    
    // Check amount field consistency
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let resultString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return resultString.isEmpty || Double(resultString) != nil
    }
}
