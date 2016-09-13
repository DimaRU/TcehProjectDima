import UIKit

// Выхывающий этот класс должен обслуживать создание записи
protocol NewEntryViewControllerDelegate {
    func entryCreated(entry: Entry)
}


class NewEntryViewController: UIViewController, CategoriesViewControllerDelegate, VenuesViewControllerDelegate {

    @IBOutlet weak var textFieldAmount: UITextField!

    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var buttonCategories: UIButton!
    
    @IBOutlet weak var buttonVenues: UIButton!
    
    var delegate: NewEntryViewControllerDelegate?
    
    var selectedVenue: String?
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cmd + / = закомментировать выделенные или текущую строку
        //или снять обратно

        //тут мы ставим текст
        textFieldAmount.text = ""
        textFieldAmount.placeholder = "Enter amount"
        
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
                
                if let venue = selectedVenue, category = selectedVenue {
                    let entry = Entry(amount: amount, venue: venue, category: category)
                    // Передать это нижестоящему классу (экрану)
                    delegate?.entryCreated(entry)
                }
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
    
    func venueSelected(venue: String) {

        dismissViewControllerAnimated(true, completion: nil)
        buttonVenues.setTitle(venue, forState: .Normal)
        
        selectedVenue = venue
    }
}
