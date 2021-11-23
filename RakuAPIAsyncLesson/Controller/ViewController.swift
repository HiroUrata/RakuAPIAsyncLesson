//
//  ViewController.swift
//  RakuAPIAsyncLesson
//
//  Created by UrataHiroki on 2021/11/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
  
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    
    private let alamofireProcess = AlamofireProcess(getKey: nil)
    
    private let dispatchGroup = DispatchGroup()
    private let dispachQueue = DispatchQueue(label: "alamofire",attributes: .concurrent)
    
    private var cellContentsArray = [GetDataDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultTableView.register(UINib(nibName: "SearchReaultCell", bundle: nil), forCellReuseIdentifier: "ItemDetailCell")
        resultTableView.delegate = self
        resultTableView.dataSource = self
    
    }

    @IBAction func search(_ sender: UIButton) {
        
        let afProcess = AlamofireProcess(getKey: searchTextField.text)
        
        dispatchGroup.enter()
        dispachQueue.async {[self] in
            
            afProcess.getItemDetailData {
                
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main){ [self] in
            
            cellContentsArray = afProcess.getDataResultArray
            print(cellContentsArray)
            resultTableView.reloadData()
        }
    }
    
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height / 2.4
    }
}


extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellContentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailCell", for: indexPath) as! SearchResultCell
        
        cell.mediumImageView.sd_setImage(with: URL(string: cellContentsArray[indexPath.row].mediumImageURL!), completed: nil)
        cell.itemNameLabel.text = cellContentsArray[indexPath.row].itemName
        cell.itemPriceLabel.text = String(cellContentsArray[indexPath.row].itemPrice!)
        cell.itemCaptionView.text = cellContentsArray[indexPath.row].itemCaption
        
        return cell
    }
}


