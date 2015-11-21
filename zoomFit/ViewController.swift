import UIKit
import SnapKit

class FullscreenImageView: UIView {
    
    let imageFullScreen : UIImageView
    let scrollView: UIScrollView
    let containerView: UIView
    let view = UIView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        
        imageFullScreen = UIImageView()
        scrollView = UIScrollView()
        containerView = UIView()
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.blackColor()
        println("layoutSubviews")
        
        containerView.addSubview(scrollView)
        scrollView.addSubview(imageFullScreen)
        addSubview(containerView)
        
        
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(superview!).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            make.center.equalTo(superview!)
        }
        
        imageFullScreen.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView.snp_width)
            make.height.equalTo(imageFullScreen.snp_width)
            make.center.equalTo(scrollView)
        }
        
        containerView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(superview!).inset(0)
            make.center.equalTo(superview!).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
    }
    
    func setZoomScale() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 1.0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class myViewController: UIViewController ,UIScrollViewDelegate{
    
    var fullScreenImageView : FullscreenImageView {
        return view as! FullscreenImageView
    }
    var imageData:UIImage!
    
    override func loadView() {
        let contentView = FullscreenImageView(frame: .zeroRect)
        view = contentView
    }
    
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //random Image
        fullScreenImageView.imageFullScreen.image = UIImage(named: "PhotonMapping.png")
        //fullScreenImageView.setZoomScale()
        
        setupGestureRecognizer()
        fullScreenImageView.scrollView.delegate = self
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return fullScreenImageView.imageFullScreen
    }
    
    override func viewWillLayoutSubviews() {
        fullScreenImageView.setZoomScale()
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        fullScreenImageView.scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (fullScreenImageView.scrollView.zoomScale > ((fullScreenImageView.scrollView.minimumZoomScale + fullScreenImageView.scrollView.maximumZoomScale)/2.0) ) {
            fullScreenImageView.scrollView.setZoomScale(fullScreenImageView.scrollView.minimumZoomScale, animated: true)
        } else {
            fullScreenImageView.scrollView.setZoomScale(fullScreenImageView.scrollView.maximumZoomScale, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
}
