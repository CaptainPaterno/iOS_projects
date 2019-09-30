//
//  ViewController.swift
//  StatePark
//
//  Created by Yixuan Zhang on 9/29/19.
//  Copyright © 2019 Yixuan Zhang. All rights reserved.
//

import UIKit

protocol PictureScrollViewDelegate{
    
    
}

class PageNumber{
    var col:Int
    var row:Int
    init(x:Int,y:Int) {
        col=x
        row=y
    }
}


class ParkScrollView: UIScrollView,UIScrollViewDelegate {
    var PictureList:[UIScrollView]=[]
    var name : String?
    var count : Int?
    
    
}

class PictureScrollView: UIScrollView {
    var PictureView:PictureView?
    
}
class PictureView: UIImageView {
    
}


class ViewController: UIViewController,UIScrollViewDelegate {
    let model=Model()
    var parkList :[ParkScrollView]=[]
    var currentPictureView:PictureView?
    var singleImageSize:CGSize=CGSize(width: 0, height: 0)
    var currentPageX : Int {return Int(masterScrollView.contentOffset.x / masterScrollView.bounds.width)}
    var currentPageY : Int {return Int(masterScrollView.contentOffset.x / masterScrollView.bounds.width)}
    var currentPage : PageNumber {return PageNumber(x: currentPageX, y: currentPageY)}

    @IBOutlet weak var masterScrollView: UIScrollView!
    typealias parkPictures = [UIImageView]
    var pictures:[parkPictures]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        for index in 0...model.allParks.count-1{
            let aParkScrollView=ParkScrollView()
            aParkScrollView.name=model.allParks[index].name
            aParkScrollView.count=model.allParks[index].count
            masterScrollView.addSubview(aParkScrollView)
            parkList.append(aParkScrollView)
            var aParkPictures = parkPictures()
            for count in 0...aParkScrollView.count!{
                let fileName = aParkScrollView.name! + "0" + "\(count+1)"
                let image=UIImage(named: fileName)
                let aPictureView = PictureView(image: image)
                aParkPictures.append(aPictureView)
                let aPictureScrollView = PictureScrollView()
                aPictureScrollView.delegate = self
                aPictureScrollView.addSubview(aPictureView)
                aParkScrollView.addSubview(aPictureScrollView)
                aParkScrollView.PictureList.append(aPictureScrollView)
            }
            pictures.append(aParkPictures)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        singleImageSize = masterScrollView.bounds.size
        masterScrollView.contentSize=CGSize(width: singleImageSize.width*CGFloat(model.allParks.count), height: singleImageSize.height)
        for index in 0...parkList.count-1{
            let aParkScrollView = parkList[index]
            let parkOrigin = CGPoint(x: CGFloat(index)*singleImageSize.width, y: 0)
            aParkScrollView.frame=CGRect(origin: parkOrigin, size: singleImageSize)
            aParkScrollView.contentSize=CGSize(width: singleImageSize.width, height: singleImageSize.height*CGFloat(aParkScrollView.count!))
            for count in 0...aParkScrollView.count!-1{
                let aPictureScrollView=aParkScrollView.PictureList[count]
                let imageScrollViewOrigin=CGPoint(x:0,y: CGFloat(count)*singleImageSize.height)
                aPictureScrollView.frame=CGRect(origin: imageScrollViewOrigin, size: singleImageSize)
                let scale = scaleFor(size: pictures[index][count].image!.size)
                aPictureScrollView.setZoomScale(0.001, animated: false)
                aPictureScrollView.minimumZoomScale = 0.001

            }
        }
    }
    
    func scaleFor(size:CGSize) -> CGFloat{
        let widthScale = singleImageSize.width/size.width
        let heightScale = singleImageSize.height/size.height
        return min(widthScale,heightScale)
        
    
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pictures[currentPage.row][currentPage.col]
    }
    
    

    
    
}
