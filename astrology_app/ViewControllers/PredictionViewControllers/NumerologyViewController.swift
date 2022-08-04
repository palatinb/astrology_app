//
//  NumerologyViewController.swift
//  astrology_app
//
//  Created by Bence Palatin on 2021. 03. 07..
//
import UIKit

class NumerologyViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    let contentView = UIView()
    var predictionObject = predictionModel()
    var responseCount = 0
    var myDict = Dictionary<String,Dictionary<String,String>>()
    var frame = CGRect.zero
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        responseCount = (predictionObject.response?.count)!
        myDict = (predictionObject.response! as! Dictionary<String,Dictionary<String,String>>)
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.titleLabe.text = myDict["destiny"]!["title"]
        slide1.numberLabel.text = myDict["destiny"]!["number"]
        slide1.descriptionLabel.text = myDict["destiny"]!["description"]
        slide1.meaningTextView.text = myDict["destiny"]!["meaning"]
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.titleLabe.text = myDict["personality"]!["title"]
        slide2.numberLabel.text = myDict["personality"]!["number"]
        slide2.descriptionLabel.text = myDict["personality"]!["description"]
        slide2.meaningTextView.text = myDict["personality"]!["meaning"]
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.titleLabe.text = myDict["attitude"]!["title"]
        slide3.numberLabel.text = myDict["attitude"]!["number"]
        slide3.descriptionLabel.text = myDict["attitude"]!["description"]
        slide3.meaningTextView.text = myDict["attitude"]!["meaning"]
        
        let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.titleLabe.text = myDict["character"]!["title"]
        slide4.numberLabel.text = myDict["character"]!["number"]
        slide4.descriptionLabel.text = myDict["character"]!["description"]
        slide4.meaningTextView.text = myDict["character"]!["meaning"]
        
        let slide5:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide5.titleLabe.text = myDict["soul"]!["title"]
        slide5.numberLabel.text = myDict["soul"]!["number"]
        slide5.descriptionLabel.text = myDict["soul"]!["description"]
        slide5.meaningTextView.text = myDict["soul"]!["meaning"]
        
        let slide6:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide6.titleLabe.text = myDict["agenda"]!["title"]
        slide6.numberLabel.text = myDict["agenda"]!["number"]
        slide6.descriptionLabel.text = myDict["agenda"]!["description"]
        slide6.meaningTextView.text = myDict["agenda"]!["meaning"]
        
        let slide7:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide7.titleLabe.text = myDict["purpose"]!["title"]
        slide7.numberLabel.text = myDict["purpose"]!["number"]
        slide7.descriptionLabel.text = myDict["purpose"]!["description"]
        slide7.meaningTextView.text = myDict["purpose"]!["meaning"]
        
        return [slide1, slide2, slide3, slide4, slide5, slide6, slide7]
    }
    
    @IBAction func leftBarButtonPressed(_ sender: UIBarButtonItem) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
