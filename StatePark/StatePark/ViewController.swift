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


class ViewController: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    let model=Model()
    var parkList :[ParkScrollView]=[]
    var currentPictureView:PictureView?
    var singleImageSize:CGSize=CGSize(width: 0, height: 0)
    var currentPageMasterX : Int?
    var currentPageMasterY : Int {return Int(masterScrollView.contentOffset.x / masterScrollView.bounds.height)}
    var currentPark: Int?
    var currentPageVerticalY: Int?
    var currentPage : PageNumber {return PageNumber(x: currentPageMasterX!, y: currentPageVerticalY!)}
    var nameTags:[UILabel]=[]
    let coverScrollView = UIScrollView()
    let imageViewForZooming = UIImageView()
    var timer = Timer()
    var pinchForMasterView : UIPinchGestureRecognizer?
    let grey=UIColor(displayP3Red: 0.247, green: 0.247, blue: 0.247, alpha: 1)

    @IBOutlet weak var masterScrollView: UIScrollView!
    @IBOutlet weak var leftArrow: UILabel!
    @IBOutlet weak var rightArrow: UILabel!
    @IBOutlet weak var upArrow: UILabel!
    @IBOutlet weak var downArrow: UILabel!
    
    typealias parkPictures = [UIImageView]
    var pictures:[parkPictures]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        masterScrollView.delegate=self
        masterScrollView.isPagingEnabled=true
        view.addSubview(coverScrollView)
        view.bringSubviewToFront(masterScrollView)
        for index in 0...model.allParks.count-1{
            let aParkScrollView=ParkScrollView()
            aParkScrollView.name=model.allParks[index].name
            aParkScrollView.count=model.allParks[index].count
            aParkScrollView.isPagingEnabled=true
            aParkScrollView.delegate=self
            coverScrollView.delegate=self
            masterScrollView.addSubview(aParkScrollView)
            parkList.append(aParkScrollView)
            let nameTag = UILabel()
            aParkScrollView.addSubview(nameTag)
            nameTag.text=model.allParks[index].name
            nameTag.textColor = .white
            nameTag.adjustsFontSizeToFitWidth=true
            nameTag.textAlignment = .center
            nameTags.append(nameTag)
            var aParkPictures = parkPictures()
            
            for count in 0...aParkScrollView.count!{
                let fileName = aParkScrollView.name! + "0" + "\(count+1)"
                let image=UIImage(named: fileName)
                let aPictureView = PictureView(image: image)
                aPictureView.contentMode = .scaleAspectFit
                aParkPictures.append(aPictureView)
                let aPictureScrollView = PictureScrollView()
                aPictureScrollView.delegate = self
                aPictureScrollView.addSubview(aPictureView)
                aPictureScrollView.isPagingEnabled=true
                aParkScrollView.addSubview(aPictureScrollView)
                aParkScrollView.PictureList.append(aPictureScrollView)
            }
            pictures.append(aParkPictures)
        }
        
        
        let selector = #selector(ViewController.zoom(_:))
        pinchForMasterView = UIPinchGestureRecognizer(target: self, action: selector)
        pinchForMasterView?.delegate = self
        self.view.addGestureRecognizer(pinchForMasterView!)
        
        
        
    }

    @objc func zoom(_ sender: UIPinchGestureRecognizer){
        
        switch sender.state {
        case .began:
            currentPageMasterX=Int(masterScrollView.contentOffset.x / masterScrollView.bounds.width)
            currentPark=currentPageMasterX
            currentPageVerticalY = Int(Double(parkList[currentPageMasterX!].contentOffset.y)/Double(singleImageSize.height))
            view?.bringSubviewToFront(coverScrollView)
            let currentPicture = pictures[currentPageMasterX!][currentPageVerticalY!]
            let scale = Double(scaleFor(size: currentPicture.image!.size))
            coverScrollView.addSubview(imageViewForZooming)
            coverScrollView.minimumZoomScale=10
            coverScrollView.maximumZoomScale=100
            imageViewForZooming.image=currentPicture.image
            coverScrollView.frame=CGRect(origin: masterScrollView.frame.origin, size: masterScrollView.frame.size)            //imageViewForZooming.frame=CGRect(x: Double(singleImageSize.width/2)-(Double(currentPicture.image!.size.width)*scale/2), y: Double(singleImageSize.height/2)-(Double(currentPicture.image!.size.height)*scale/2), width: Double(currentPicture.image!.size.width)*scale, height:Double(currentPicture.image!.size.height)*scale)
            imageViewForZooming.frame=CGRect(x: 0, y: 0, width: Double(currentPicture.image!.size.width)*scale, height:Double(currentPicture.image!.size.height)*scale)
            imageViewForZooming.center=centerForImage()
            coverScrollView.contentSize=CGSize(width: imageViewForZooming.image!.size.width*CGFloat(scale), height: imageViewForZooming.image!.size.height*CGFloat(scale))
            coverScrollView.bringSubviewToFront(imageViewForZooming)
            coverScrollView.backgroundColor = masterScrollView.backgroundColor
            view.bringSubviewToFront(coverScrollView)
            coverScrollView.isScrollEnabled=true
            
            
        case .changed:
            let senderScale=sender.scale
            let currentZoomScale=coverScrollView.zoomScale
            coverScrollView.setZoomScale(coverScrollView.zoomScale+senderScale, animated: false)
        case .ended:
            let currentZoomScale=coverScrollView.zoomScale
            let minimumZoomScale=coverScrollView.minimumZoomScale
            //if coverScrollView.zoomScale==coverScrollView.minimumZoomScale{
                //self.view.bringSubviewToFront(masterScrollView)
                //self.view.sendSubviewToBack(coverScrollView)
            //}
        default:
            break
        }
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        singleImageSize = masterScrollView.bounds.size
        masterScrollView.contentSize=CGSize(width: singleImageSize.width*CGFloat(model.allParks.count), height: singleImageSize.height)
        coverScrollView.frame=CGRect(origin: masterScrollView.frame.origin, size: masterScrollView.frame.size)
        imageViewForZooming.center=centerForImage()
        
        for index in 0...parkList.count-1{
            let aParkScrollView = parkList[index]
            let parkOrigin = CGPoint(x: CGFloat(index)*singleImageSize.width, y: 0)
            aParkScrollView.frame=CGRect(origin: parkOrigin, size: singleImageSize)
            aParkScrollView.contentSize=CGSize(width: singleImageSize.width, height: singleImageSize.height*CGFloat(aParkScrollView.count!))
            nameTags[index].frame=CGRect(x: 0, y: 10, width: singleImageSize.width, height: 30)
            aParkScrollView.bringSubviewToFront(nameTags[index])
            for count in 0...aParkScrollView.count!-1{
                let aPictureScrollView=aParkScrollView.PictureList[count]
                
                let imageScrollViewOrigin=CGPoint(x:0,y: CGFloat(count)*singleImageSize.height)
                
                aPictureScrollView.frame=CGRect(origin: imageScrollViewOrigin, size: singleImageSize)
                let aPictureView = pictures[index][count]
                let scale = Double(scaleFor(size: aPictureView.image!.size))
                aPictureView.frame = CGRect(x: Double(singleImageSize.width/2)-(Double(aPictureView.image!.size.width)*scale/2), y: Double(singleImageSize.height/2)-(Double(aPictureView.image!.size.height)*scale/2), width: Double(aPictureView.image!.size.width)*scale, height:Double(aPictureView.image!.size.height)*scale)
                aPictureScrollView.contentSize = singleImageSize
              
                
                
                

            }
        }
    }
    
    func scaleFor(size:CGSize) -> CGFloat{
        let widthScale = singleImageSize.width/size.width
        let heightScale = singleImageSize.height/size.height
        return min(widthScale,heightScale)
        
    
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewForZooming
    }
    
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if coverScrollView.zoomScale==coverScrollView.minimumZoomScale {
            self.view.bringSubviewToFront(masterScrollView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageViewForZooming.center=centerForImage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    

    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageMasterX=Int(masterScrollView.contentOffset.x / masterScrollView.bounds.width)
        currentPark=currentPageMasterX
        currentPageVerticalY = Int(Double(parkList[currentPageMasterX!].contentOffset.y)/Double(singleImageSize.height))
        if(currentPageVerticalY != 0){
            
            print(currentPageVerticalY!)
            print(parkList[currentPageMasterX!].count!)
            if (currentPageVerticalY==parkList[currentPageMasterX!].count!-1){
                downArrow.isHidden=true
            }else{
            masterScrollView.isScrollEnabled=false
            leftArrow.isHidden=true
            rightArrow.isHidden=true
            upArrow.isHidden=false
            downArrow.isHidden=false
            }
        }else{
            if(currentPageMasterX==0){
                leftArrow.isHidden=true
            }else{
                leftArrow.isHidden=false
            }
            
            if(currentPageMasterX==parkList.count-1){
                rightArrow.isHidden=true
            }else{
                rightArrow.isHidden=false
            }
            masterScrollView.isScrollEnabled=true
            upArrow.isHidden=true
            downArrow.isHidden=false
            
        }
        timer=Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(hideArrors), userInfo: nil, repeats: false)
    }

    @objc func hideArrors(){
        upArrow.isHidden=true
        downArrow.isHidden=true
        leftArrow.isHidden=true
        rightArrow.isHidden=true
    }
    
    func centerForImage() -> CGPoint {
        
        var imageCenter = CGPoint(x: coverScrollView.contentSize.width/2.0,
                                  y: coverScrollView.contentSize.height/2.0)
        
        
        let scrollViewSize = coverScrollView.bounds.size
        let scrollViewCenter = coverScrollView.center
       
        
        if (coverScrollView.contentSize.width < scrollViewSize.width) {
            imageCenter.x = scrollViewCenter.x;
        }
        
        if (coverScrollView.contentSize.height < scrollViewSize.height) {
            imageCenter.y = scrollViewCenter.y;
        }
        return imageCenter
    }
    
}
