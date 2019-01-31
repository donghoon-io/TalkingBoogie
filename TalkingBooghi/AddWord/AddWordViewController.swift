//
//  AddWordViewController.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 23..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit

extension AddWordViewController: DragDropCellDelegate {
    func delete(cell: DragDropViewCell) {
        if let indexPath = collectionView2?.indexPath(for: cell) {
            items2.remove(at: indexPath.item)
            collectionView2.deleteItems(at: [indexPath])
        }
    }
}

class AddWordViewController: UIViewController, UITextFieldDelegate {
    
    
    private var items1 = [String]()
    private var items2 = [String]()
    
    var imageToBeSet = UIImage()
    var categoryString = String()
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        let nowDate = getTodayString()
        let a = ImageSet.init(category: categoryString, imageName: title!, imagePath: nowDate, tagName: [], tagPath: [], cardType : "default", isEditable: true)
//        a.tag = items2
        imageSets.append(a)
        saveDocumentImage(img: imageToBeSet, imgPath: nowDate)
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
    @IBOutlet var tagView: UIView!
    
    
    @IBOutlet weak var findTextField: UITextField! {
        didSet {
            findTextField.placeholder = "단어를 검색해주세요"
        }
    }
    
    @IBAction func textFieldEdited(_ sender: UITextField) {
        let titleItself = title!.components(separatedBy: " ")
        let titleArray = titleItself.filter {
            $0 != ""
        }
        if sender.text?.count ?? 0 > 0 {
            let a = sender.text!.components(separatedBy: " ")
            items1 = titleArray + a.filter({
                $0 != ""
            })
        } else {
            items1 = titleArray
        }
        collectionView1.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleItself = title!.components(separatedBy: " ")
        items1 = titleItself.filter {
            $0 != ""
        }
        
        findTextField.delegate = self
        
        collectionView1.dataSource = self
        collectionView2.dataSource = self
        
        originalImageView.image = imageToBeSet
        
        self.collectionView1.dragInteractionEnabled = true
        self.collectionView1.dragDelegate = self
        self.collectionView1.dropDelegate = self
        
        //CollectionView-2 drag and drop configuration
        self.collectionView2.dragInteractionEnabled = true
        self.collectionView2.dropDelegate = self
        self.collectionView2.dragDelegate = self
        self.collectionView2.reorderingCadence = .fast
    }
    
    func textFieldShouldReturn(_ findTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.collectionView2
                {
                    self.items2.remove(at: sourceIndexPath.row)
                    self.items2.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                else
                {
                    self.items1.remove(at: sourceIndexPath.row)
                    self.items1.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === self.collectionView2
                {
                    self.items2.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                else
                {
                    self.items1.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
}

extension AddWordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView1 {
            return self.items1.count
        } else {
            return self.items2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! DragDropViewCell
            if UIImage(named: self.items1[indexPath.row]) != nil {
                cell.wordImage.image = UIImage(named: self.items1[indexPath.row])
            }
            
            cell.wordLabel.text = self.items1[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! DragDropViewCell
            cell.wordImage?.image = UIImage(named: self.items2[indexPath.row])
            cell.wordLabel.text = self.items2[indexPath.row]
            cell.delegate3 = self
            
            return cell
        }
    }
}

extension AddWordViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = collectionView == collectionView1 ? self.items1[indexPath.row] : self.items2[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let item = collectionView == collectionView1 ? self.items1[indexPath.row] : self.items2[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        if collectionView == collectionView1 {
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 90, height: 120))
            return previewParameters
        }
        return nil
    }
}

// MARK: - UICollectionViewDropDelegate Methods
extension AddWordViewController: UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView === self.collectionView1
        {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        } else {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
            
        case .copy:
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            
        default:
            return
        }
    }
}
