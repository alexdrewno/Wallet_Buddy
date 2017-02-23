import UIKit
class WalletViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet var collectionView: UICollectionView!
    var photos : [UIImage] = []
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
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
        let addPic = UIAlertController(title: "Add a new photo", message: "", preferredStyle: .alert)
        addPic.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) in
            self.presentPhotoPicker(false)
        }))
        addPic.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            self.presentPhotoPicker(true)
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
