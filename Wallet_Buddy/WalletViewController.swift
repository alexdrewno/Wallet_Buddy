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
        return UICollectionViewCell()
        
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
    
}
