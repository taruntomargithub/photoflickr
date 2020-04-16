//
//  ImageSearchViewController.swift
//  PhotoFlikr
//
//  Created by Varun Tomar on 21/03/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "Cell"
//var modelData = ["Oliver","Harry","George","Jack","Noah"]
//var dataArray:[Photo] = []
//var imageModelData: [UIImage?] = [
//  UIImage(named: "image1"),
//  UIImage(named: "image2"),
//  UIImage(named: "image3"),
//  UIImage(named: "image4"),
//  UIImage(named: "image5")
//]


class ImageSearchViewController: UICollectionViewController {
    
    fileprivate var searchBar = UISearchBar()
    fileprivate let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 0.0, right: 16.0)
    fileprivate var numberOfCellInArow:CGFloat = 3.0
    fileprivate var cellPadding:CGFloat = 16.0
    fileprivate var isLoading = false
    var pageIndex = 1
   
    var viewModel: ImageSearchViewModel = ImageSearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.navigationBarSetUp()
        //self.fetchData()
                
        viewModel.dataArray.addObserverAndNotify { (_) in
            //Refrsh collection view
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageIndex += 1
        fetchImages(pageCount: pageIndex)
    }
    
//    func fetchData(searchText: String, pageCount: Int) {
//           Alamofire.request("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=75f49785083cf8953a3febfae04469da&format=json&nojsoncallback=1&page=\(pageCount)&text=\(searchText)&per_page=20").responseJSON { response in
//            guard let data = response.data else {return}
//            do {
//                let photosOutput = try JSONDecoder().decode(Photos.self, from: data)
//                dataArray.append(contentsOf: photosOutput.photos.photo)
//                //Relaod collection view
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            }
//            catch let jsonErr {
//                    print("Error:", jsonErr)
//            }
//        }
//    }
    
    func navigationBarSetUp() {
        searchBar.placeholder = "Search Images"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        let optionBtn = UIBarButtonItem(image: UIImage(named: "threeDots"), style: .plain, target: self, action: #selector(optionTapped))
        self.navigationItem.rightBarButtonItem = optionBtn
    }
    
    @objc func optionTapped() {
        let optionMenu = UIAlertController(title: "Select", message: "Number of images per row", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "2", style: .default) {[unowned self] (action) in
            self.numberOfCellInArow = 2
            self.collectionView.reloadData()
        }
        let action2 = UIAlertAction(title: "3", style: .default) {[unowned self] (action) in
            self.numberOfCellInArow = 3
            self.collectionView.reloadData()
        }
        let action3 = UIAlertAction(title: "4", style: .default) {[unowned self] (action) in
            self.numberOfCellInArow = 4
            self.collectionView.reloadData()
        }
        let action4 = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
        }
        optionMenu.addAction(action1)
        optionMenu.addAction(action2)
        optionMenu.addAction(action3)
        optionMenu.addAction(action4)
        self.present(optionMenu, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.dataArray.value.count//dataArray.count//imageModelData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        // Configure the cell
        //cell.titleLbl.text = modelData[indexPath.row]
        //cell.imageView.image = imageModelData[indexPath.row]
        cell.imageView.image = UIImage(named: "placeholder")
        let tempObj = viewModel.dataArray.value[indexPath.row]
        if let imageUrl = tempObj.getImagePath() {
            Alamofire.request(imageUrl, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                DispatchQueue.main.async {
                    // Refresh you views
                    cell.imageView.image = UIImage(data: responseData.data!)
                }
            })
        }
        
//        if (indexPath.row == (dataArray.count - 1)) {
//            pageIndex+=1
//            fetchImages(pageCount: pageIndex)
//        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
//MARK: - SearchBar Delegate
extension ImageSearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        //Reset old data first befor new search Results
     //   self.viewModel.resetValuesForNewSearch()
        guard let text = searchBar.text?.removeSpace,
            text.count != 0  else {
             //   loadingLbl.text = "Please type keyword to search result."
                return
        }
        //Requesting new keyword
        self.fetchImages(pageCount: pageIndex)
       // loadingLbl.text = "Searching Images..."
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width - 2 * 16;
        let itemWidth = collectionWidth / numberOfCellInArow - (cellPadding) + cellPadding/numberOfCellInArow;
        
        return CGSize(width: itemWidth, height: itemWidth);
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func fetchImages(pageCount: Int) {
        let searchImage: String? = searchBar.text
        let pageNumber = pageCount
        viewModel.fetchData(searchText:searchImage ?? "", pageCount:pageNumber)
        
    }
}
