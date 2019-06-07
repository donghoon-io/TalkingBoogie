import UIKit
import Alamofire
import SwiftyJSON

protocol SendAACProtocol {
    func sendImage(image: UIImage)
}

class SearchAACViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var imageDelegate: SendAACProtocol!
    
    var imageArray = [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchAACCell", for: indexPath) as! SearchViewCell
        cell.imageView.image = imageArray[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageDelegate.sendImage(image: imageArray[indexPath.item])
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var navBar: UINavigationBar! {
        didSet {
            navBar.setBackgroundImage(UIImage(), for:.default)
            navBar.shadowImage = UIImage()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
        }
    }
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let str = searchBar.text {
            let searchArray = dataSet.filter({$0.contains(str)})
            imageArray = searchArray.map({ (str) -> UIImage in
                return UIImage(named: str) ?? UIImage()
            })
        }
        
        searchBar.resignFirstResponder()
        self.searchCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        let layout = self.searchCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        let itemWidth: CGFloat = (self.searchCollectionView.frame.size.width - 50)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
}
