import UIKit
import AKPickerView

class WalletViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AKPickerViewDelegate, AKPickerViewDataSource
{
    @IBOutlet var collectionView: UICollectionView!
    var imagePicker = UIImagePickerController()
    @IBOutlet var pickerViewFrame: UIView!
    var pickerView: AKPickerView!
    var categoryDictionary : [String : [UIImage]] = ["IDs" : []]
    var selectedKey = ""
    
    override func viewDidLoad()
    {
        let defaults = UserDefaults.standard
        if let savedCategories = defaults.object(forKey: "categories") as? Data
        {
            categoryDictionary = NSKeyedUnarchiver.unarchiveObject(with: savedCategories) as! [String : [UIImage]]
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.pickerView = AKPickerView(frame: pickerViewFrame.frame)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    
        self.view.addSubview(pickerView)
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 45)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 45)!
        self.pickerView.pickerViewStyle = .style3D
        self.pickerView.isMaskDisabled = false
        self.pickerView.interitemSpacing = 25
        self.pickerView.reloadData()
//        self.categoryDictionary["IDs"] = []
//        self.pickerView.reloadData()
//        self.collectionView.reloadData()
//        self.save()
        self.selectedKey = (categoryDictionary as NSDictionary).allKeys[0] as! String
        let screenSize : CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: 180)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    func pickerView(_ pickerView: AKPickerView!, didSelectItem item: Int) {
        
        collectionView.reloadData()

    }
    
    func pickerView(_ pickerView: AKPickerView!, configureLabel label: UILabel!, forItem item: Int) {
        
    }
    
    func pickerView(_ pickerView: AKPickerView!, titleForItem item: Int) -> String! {
        selectedKey = (categoryDictionary as NSDictionary).allKeys[item] as! String
        return selectedKey
    }
    
    func numberOfItems(in pickerView: AKPickerView!) -> UInt {
        return UInt(categoryDictionary.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        if let imageArray = categoryDictionary[selectedKey]
        {
            let photo = imageArray[indexPath.row]
            cell.cellImage.image = photo
        }
        else
        {
            print("couldn't find key \(selectedKey)")
        }
        
        

        //let path = getDocumentsDirectory().appendingPathComponent(person.image)
        //cell.cellImage.image = UIImage(contentsOfFile: path.path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if selectedKey == ""
        {
            return 0
        }
        return categoryDictionary[selectedKey]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let ac = UIAlertController(title: "Remove or Share", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler:
            {
                (action:UIAlertAction!) -> Void in
                self.categoryDictionary[self.selectedKey]?.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
                self.save()
        }))
        ac.addAction(UIAlertAction(title: "Share", style: .default, handler:
            {
                (action:UIAlertAction!) -> Void in
                let imageToShare = [self.categoryDictionary[self.selectedKey]?[indexPath.item]]
                let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.postToFacebook]
                self.present(activityViewController, animated: true, completion: nil)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated : true)
    }
    
    @IBAction func addPhoto(_ sender: AnyObject)
    {
        let ac = UIAlertController(title: "Name The Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            self.categoryDictionary[newName.text!] = []
            self.pickerView.reloadData()
            self.collectionView.reloadData()
            self.save()
        }))
        
        let addPic = UIAlertController(title: "Add a new photo", message: "", preferredStyle: .alert)
        addPic.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
            self.presentPhotoPicker(false)
        }))
        addPic.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            self.presentPhotoPicker(true)
        }))
        addPic.addAction(UIAlertAction(title: "Add New Category", style: .default, handler: { (action) in
            self.present(ac, animated: true)
        }))
        addPic.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(addPic, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(_ camera : Bool)
    {
        imagePicker.sourceType = .photoLibrary
        if camera
        {
            imagePicker.sourceType = .camera
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(image, 80)
        {
            try? jpegData.write(to: imagePath, options: [.atomic])
        }
        categoryDictionary[selectedKey]!.append(image)
        collectionView.reloadData()
        save()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func barTrashTap(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Delete:", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "All Photos", style: .default, handler:
            {
                (action:UIAlertAction!) -> Void in
                self.categoryDictionary[self.selectedKey]?.removeAll()
                self.collectionView.reloadData()
                self.save()
        }))
        ac.addAction(UIAlertAction(title: "Category", style: .default, handler:
            {
                (action:UIAlertAction!) -> Void in
                //Need something here
                
                let index = (self.categoryDictionary as NSDictionary).allKeys.index(where: { (item) -> Bool in
                    item as! String == self.selectedKey
                })
                print(index!)
                
                print(self.categoryDictionary.removeValue(forKey: self.selectedKey) == nil)
                
                var newIndex = 0
                if index != 0{
                    newIndex = index!-1
                    self.selectedKey = (self.categoryDictionary as NSDictionary).allKeys[newIndex] as! String
                    self.pickerView.selectItem(UInt(newIndex), animated: true)
                }
                else
                {
                    self.selectedKey = ""
                }
                print(self.selectedKey)
                
                self.collectionView.reloadData()
                self.pickerView.reloadData()
                self.save()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated : true)
    }
    
    func save()
    {
        //NSKeyedArchiver converts array into a data object
        let savedData = NSKeyedArchiver.archivedData(withRootObject: categoryDictionary)
        
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "categories")
    }
}
