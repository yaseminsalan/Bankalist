        //
        //  BankaDetayViewController.swift
        //  enquraCase
        //
        //

        import UIKit
        import GravitySliderFlowLayout
        import CoreLocation
        import Firebase
        import FirebaseCore


        class BankaDetayViewController: UIViewController {
            var bankaDetay = BankaModel()
            @IBOutlet weak var priceButton: UIButton!
            @IBOutlet weak var pageControl: UIPageControl!
            @IBOutlet weak var collectionView: UICollectionView!
            @IBOutlet weak var productSubtitleLabel: UILabel!
            @IBOutlet weak var productTitleLabel: UILabel!
            
            let images = [#imageLiteral(resourceName: "bank"), #imageLiteral(resourceName: "real-estate"), #imageLiteral(resourceName: "blood-type"), #imageLiteral(resourceName: "boolean"), #imageLiteral(resourceName: "atm-machine")]
            var titles:[String] = ["Banka Adı","Banka Adresi","Banka Tipi","Banka Durumu","En Yakın ATM"];
            var subtitles:[String] = []
            let prices = ["", "", "","","Yol Tarifi Al"]
            
            let collectionViewCellHeightCoefficient: CGFloat = 0.85
            let collectionViewCellWidthCoefficient: CGFloat = 0.55
            let priceButtonCornerRadius: CGFloat = 10
            let gradientFirstColor = UIColor(named: "ff8181")?.cgColor
            let gradientSecondColor = UIColor(named: "a81382")?.cgColor
            let cellsShadowColor = UIColor(named: "2a002a")?.cgColor
            let productCellIdentifier = "ProductCollectionViewCell"
            var geocoder = CLGeocoder()
            var lat:Double = 0.0;
            var lon:Double = 0.0;
            private var itemsNumber = 1000
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
            }
            override func viewDidLoad() {
                super.viewDidLoad()
                let logo = UIImage(named: "enqura.png")
                let imageView = UIImageView(image:logo)
                imageView.contentMode = .scaleAspectFit
                self.navigationItem.titleView = imageView
               
                subtitles = [bankaDetay.dc_BANKA_SUBE,bankaDetay.dc_ADRES,bankaDetay.dc_BANKA_TIPI,bankaDetay.dc_ON_OFF_LINE,bankaDetay.dc_EN_YAKIM_ATM]
                configureCollectionView()
                configurePriceButton()
               
                geocoder.geocodeAddressString(bankaDetay.dc_ADRES) {
                    placemarks, error in
                    let placemark = placemarks?.first
                    self.lat = (placemark?.location?.coordinate.latitude)!
                    self.lon = (placemark?.location?.coordinate.longitude)!
                    print("Lat: \(self.lat), Lon: \(self.lon)")
                }
                
                //şube detayları Firebase analytics kullanılarak loglandı.
                // 1
                FirebaseAnalytics.Analytics.logEvent("detail_screen_viewED", parameters: [
                  // 2
                  AnalyticsParameterScreenName: "banka_detay_view",
                  "ID" : bankaDetay.ID,
                  "dc_SEHIR" : bankaDetay.dc_SEHIR,
                  "dc_ILCE" : bankaDetay.dc_ILCE,
                  "dc_BANKA_SUBE" : bankaDetay.dc_BANKA_SUBE,
                  "dc_BANKA_TIPI" : bankaDetay.dc_BANKA_TIPI,
                  "dc_BANK_KODU" : bankaDetay.dc_BANK_KODU,
                  "dc_ADRES_ADI" : bankaDetay.dc_ADRES_ADI,
                  "dc_ADRES" : bankaDetay.dc_ADRES,
                  "dc_POSTA_KODU" : bankaDetay.dc_POSTA_KODU,
                  "dc_ON_OFF_LINE" : bankaDetay.dc_ON_OFF_LINE,
                  "dc_ON_OFF_SITE" : bankaDetay.dc_ON_OFF_SITE,
                  "dc_BOLGE_KOORDINATORLUGU" : bankaDetay.dc_BOLGE_KOORDINATORLUGU,
                  "dc_EN_YAKIM_ATM" : bankaDetay.dc_EN_YAKIM_ATM
                ])

            }
           
            private func configureCollectionView() {
                
                let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
                self.productTitleLabel.text = self.titles[0]
                self.productSubtitleLabel.text = self.subtitles[0]
               
                collectionView.collectionViewLayout = gravitySliderLayout
                collectionView.dataSource = self
                collectionView.delegate = self
                
                gravitySliderLayout.collectionView?.reloadData()
            }
            
            private func configurePriceButton() {
                priceButton.layer.cornerRadius = priceButtonCornerRadius
                
            }
            
            private func configureProductCell(_ cell: ProductCollectionViewCell, for indexPath: IndexPath) {
                cell.clipsToBounds = false
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = cell.bounds
                gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
                gradientLayer.cornerRadius = 21
                gradientLayer.masksToBounds = true
                cell.layer.insertSublayer(gradientLayer, at: 0)
                
                cell.layer.shadowColor = cellsShadowColor
                cell.layer.shadowOpacity = 0.2
                cell.layer.shadowRadius = 20
                cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
                
                cell.productImage.image = images[indexPath.row % images.count]
                
            
                cell.banka_bilgi_lbl.layer.cornerRadius = 8
                cell.banka_bilgi_lbl.clipsToBounds = true
                cell.banka_bilgi_lbl.layer.borderColor = UIColor.white.cgColor
                cell.banka_bilgi_lbl.layer.borderWidth = 1.0
               
               
            }
            
            private func animateChangingTitle(for indexPath: IndexPath) {
                UIView.transition(with: productTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.productTitleLabel.text = self.titles[indexPath.row % self.titles.count]
                }, completion: nil)
                UIView.transition(with: productSubtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.productSubtitleLabel.text = self.subtitles[indexPath.row % self.subtitles.count]
                }, completion: nil)
                UIView.transition(with: priceButton, duration: 0.3, options: .transitionCrossDissolve,animations: {
                    self.priceButton.setTitle(self.prices[indexPath.row % self.prices.count], for: .normal)
                }, completion: nil)
               
               
            }
            
           
            
            @IBAction func priceButton(_ sender: Any) {
                print("deneme\((sender as AnyObject).titleLabel!.text)")
                UIApplication.shared.open(URL(string:"http://maps.apple.com/?daddr=\(lat ?? 0.0),\(lon ?? 0.0)")!, options: [:], completionHandler: nil)
            }
        }

        extension BankaDetayViewController: UICollectionViewDataSource {
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return itemsNumber
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCollectionViewCell
               
                self.configureProductCell(cell, for: indexPath)
                return cell
            }
            
            
        }

        extension BankaDetayViewController: UICollectionViewDelegate {
            func scrollViewDidScroll(_ scrollView: UIScrollView) {
                let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
                let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 20, y: collectionView.center.y + scrollView.contentOffset.y)
                let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 20, y: collectionView.center.y + scrollView.contentOffset.y)
                
                if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst), let indexPathSecond = collectionView.indexPathForItem(at: locationSecond), let indexPathThird = collectionView.indexPathForItem(at: locationThird), indexPathFirst.row == indexPathSecond.row && indexPathSecond.row == indexPathThird.row && indexPathFirst.row != pageControl.currentPage {
                    pageControl.currentPage = indexPathFirst.row % images.count
                    
                    self.animateChangingTitle(for: indexPathFirst)
                }
            }
        }

