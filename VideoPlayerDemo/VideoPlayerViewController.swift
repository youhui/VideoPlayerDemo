import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    private var player: AVPlayer!
    
    private var playerLayer: AVPlayerLayer!
    
    private(set) var isPlaying: Bool = false
    
    private lazy var controlsContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.startAnimating()
        activityView.center = self.view.center
        return activityView
    }()
    
    private lazy var playButton: UIButton = {
        let y = kScreenHeight - (kSafeAreaBottomHeight + 48)
        let button = UIButton(frame: CGRect(x:15, y:y, width:30, height:30))
        button.setImage(UIImage(named: "icon_pause1"), for: .normal)
        button.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let y = kStatusBarHeight + 5
        let button = UIButton(frame: CGRect(x:15, y:y, width:30, height:30))
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentTimeLab: UILabel = {
        let y = kScreenHeight - (kSafeAreaBottomHeight + 41)
        let label = UILabel(frame: CGRect(x:46, y:y, width:36, height:16))
        label.textAlignment = .center
        label.text = "0:00"
        label.textColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var totalTimeLab: UILabel = {
        let x = kScreenWidth - 45
        let y = kScreenHeight - (kSafeAreaBottomHeight + 41)
        let label = UILabel(frame: CGRect(x:x, y:y, width:36, height:16))
        label.textAlignment = .center
        label.text = "0:00"
        label.textColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var sliderView: UISlider = {
        let y = kScreenHeight - (kSafeAreaBottomHeight + 41)
        let width = kScreenWidth - (85 + 50)
        let slider = UISlider.init(frame: CGRect(x:85, y:y, width:width, height:16))
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: UIControlState())
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc private func handleSliderChange() {
        if let duration = player.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            if totalSeconds > 0.0 {
                let value = Float64(sliderView.value) * Float64(totalSeconds)
                let seekTime = CMTime(value: Int64(value), timescale: 1)
                player.seek(to: seekTime, completionHandler: { (completedSeek) in
                    self.player.play()
                })
            }
        }
    }
    
    @objc private func closeAction(_ sender: UIButton) {
        self.player.pause()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func playAction(_ sender: UIButton) {
        if isPlaying {
            player.pause()
            playButton.setImage(UIImage.init(named: "icon_playing"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage.init(named: "icon_pause1"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.addObservers()
    }
    
    private func setupUI() {
        setupPlayer()
        
        setupGradientLayer()
        
        self.view.addSubview(indicatorView)
        self.view.addSubview(controlsContainerView)
        controlsContainerView.frame = self.view.bounds
        
        controlsContainerView.addSubview(playButton)
        controlsContainerView.addSubview(currentTimeLab)
        controlsContainerView.addSubview(sliderView)
        controlsContainerView.addSubview(totalTimeLab)
        
        self.view.addSubview(closeButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view.addGestureRecognizer(tap)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        removeObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func playbackFinished (_ notification: NSNotification) {
        self.player.seek(to: CMTimeMake(0, 1))
        self.player.play()
    }
    
    @objc private func tapHandler() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if controlsContainerView.isHidden {
            controlsContainerView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsContainerView.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsContainerView.alpha = 0
            }, completion: { (completed) in
                self.controlsContainerView.isHidden = true
            })
        }
        
        self.perform(#selector(autoHiddenControlsContainerView), with: nil, afterDelay: 3.0)
    }
    
    @objc private func autoHiddenControlsContainerView() {
        if !controlsContainerView.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.controlsContainerView.alpha = 0
            }, completion: { (completed) in
                self.controlsContainerView.isHidden = true
            })
        }
    }
    
    private func setupPlayer() {
        
        self.view.backgroundColor = .black
        
        let urlString = "http://7xr4xn.media1.z0.glb.clouddn.com/snh48sxhsy.mp4"
        guard let videoUrl = URL(string: urlString) else { return }
        
        player = AVPlayer(url: videoUrl)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        
        player.play()
        
        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(seconds / 60))
            
            self.currentTimeLab.text = "\(minutesString):\(secondsString)"
            
            //lets move the slider thumb
            if let duration = self.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.sliderView.value = Float(seconds / durationSeconds)
            }
        })
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.8).cgColor]
        layer.locations = [0, 0.8, 1.0]
        layer.frame = self.view.bounds
        return layer
    }()
    
    private func setupGradientLayer() {
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status", player.status == .readyToPlay {
            indicatorView.stopAnimating()
            playButton.isHidden = false
            isPlaying = true
        }
        
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = player.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                totalTimeLab.text = "\(minutesText):\(secondsText)"
            }
        }
    }
}
