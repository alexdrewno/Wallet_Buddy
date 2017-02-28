import UIKit
import AKPickerView

class WalletViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AKPickerViewDelegate, AKPickerViewDataSource
{
    @IBOutlet var collectionView: UICollectionView!
    var photos : [UIImage] = []
    var imagePicker = UIImagePickerController()
    @IBOutlet var pickerViewFrame: UIView!
    var pickerView: AKPickerView!
    var categoryNames : [String] = ["IDs"]
    
    override func viewDidLoad() {
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
    }
    
    func pickerView(_ pickerView: AKPickerView!, didSelectItem item: Int) {
    }
    
    func pickerView(_ pickerView: AKPickerView!, configureLabel label: UILabel!, forItem item: Int) {
        
    }
    
    func pickerView(_ pickerView: AKPickerView!, titleForItem item: Int) -> String! {
        return categoryNames[item]
    }
    
    func numberOfItems(in pickerView: AKPickerView!) -> UInt {
        return UInt(categoryNames.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        let photo = photos[indexPath.item]
        
        cell.cellImage.image = photo
        //let path = getDocumentsDirectory().appendingPathComponent(person.image)
        //cell.cellImage.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    @IBAction func addPhoto(_ sender: AnyObject)
    {
        let ac = UIAlertController(title: "Name The Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            self.categoryNames.append(newName.text!)
            self.pickerView.reloadData()
            self.collectionView.reloadData()
            //self.save()
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
        photos.append(image)
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
}
