//
//  ViewController.swift
//  enquraCase
//
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift

class ViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
    var filterEmptyControl:Bool = false
    var cancelControl:Bool=false
    let searchController = UISearchController(searchResultsController: nil)
    var bankaListModel: [BankaModel] = []
    var filterdata:[BankaModel] = []
    var searcbartext:String = ""
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "enqura.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        tableview.delegate = self
        tableview.dataSource = self
        downloadBankInformation()
        searchController.searchBar.isHidden = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        //        searchController.searchBar.showsCancelButton = true
        self.searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.showsCancelButton = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here...".localized()
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame = CGRect(x: 0.0, y: 0, width: self.view.frame.width, height: 36)
        tableview.tableHeaderView = searchController.searchBar
        tableview.reloadData()
        searchController.searchBar.isHidden = false
        //internet kontrolü
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            print("Timer fired!")
            
            if Connectivity.isConnectedToInternet() == true {
                // timer.invalidate()
                
            }
            else{
                //timer.invalidate()
                let alert = UIAlertController(title: "No Internet connection".localized(), message: "Make sure your device is connected to the internet".localized(), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
        }
        
        
    }
    private func downloadBankInformation()
    {
        let request = AF.request("https://raw.githubusercontent.com/fatiha380/mockjson/main/bankdata")
        
        request.responseJSON { (data) in
            
            switch data.result{
                
            case .success(let value):
                let json=JSON(value)
                if json.count > 0{
                    for i in 0..<json.count
                    {
                        let bankaList=BankaModel()
                        bankaList.ID = json[i]["ID"].intValue
                        bankaList.dc_SEHIR = json[i]["dc_SEHIR"].stringValue
                        bankaList.dc_ILCE = json[i]["dc_ILCE"].stringValue
                        bankaList.dc_BANKA_SUBE = json[i]["dc_BANKA_SUBE"].stringValue
                        bankaList.dc_BANKA_TIPI = json[i]["dc_BANKA_TIPI"].stringValue
                        bankaList.dc_BANK_KODU = json[i]["dc_BANK_KODU"].stringValue
                        bankaList.dc_ADRES_ADI = json[i]["dc_ADRES_ADI"].stringValue
                        bankaList.dc_ADRES = json[i]["dc_ADRES"].stringValue
                        bankaList.dc_POSTA_KODU = json[i]["dc_POSTA_KODU"].stringValue
                        bankaList.dc_ON_OFF_LINE = json[i]["dc_ON_OFF_LINE"].stringValue
                        bankaList.dc_ON_OFF_SITE = json[i]["dc_ON_OFF_SITE"].stringValue
                        bankaList.dc_BOLGE_KOORDINATORLUGU = json[i]["dc_BOLGE_KOORDINATORLUGU"].stringValue
                        bankaList.dc_EN_YAKIM_ATM = json[i]["dc_EN_YAKIM_ATM"].stringValue
                        self.bankaListModel.append(bankaList)
                        
                        
                        
                    }
                    LoadingOverlay.shared.hideOverlayView()
                    self.tableview.reloadData()
                }else{
                    let alert = UIAlertController(title: "Warning".localized(), message: "Currently No Bank Information.".localized(), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .failure(let error):
                let alert = UIAlertController(title: "Error".localized(), message: "An Error Has Occurred. Please Try Again Later.".localized(), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String) {
        cancelControl = false
        searcbartext = searchText
        filterdata = searchText.isEmpty ? bankaListModel : bankaListModel.filter { $0.dc_SEHIR.lowercased().contains(searchText.lowercased())}
        
        
        if searchText.isEmpty == false && filterdata.count == 0
        {
            filterEmptyControl = true
            
            
        }
        else
        {
            
            filterEmptyControl = false
            
            
        }
        tableview.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        cancelControl = true
        searchController.searchBar.isHidden = false
        searchController.searchBar.resignFirstResponder()
        filterdata.removeAll()
        tableview.reloadData()
        tableview.delegate = self
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if filterdata.count != 0 || filterEmptyControl{
            
            if filterdata.count == 0 {
                
                if cancelControl {
                    
                    return bankaListModel.count
                }else{
                    return 0
                    
                }
            }
            else{
             
                return filterdata.count
            }
            
        }
        else{
            return bankaListModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homepageCell", for: indexPath) as! HomepageTableViewCell
        
        
        if filterdata.count != 0 || filterEmptyControl
        {
            if filterdata.count == 0
            {
                
                if cancelControl
                {
                    
                    cell.sube_lbl.text = bankaListModel[indexPath.row].dc_BANKA_SUBE
                    cell.adres_lbl.text = bankaListModel[indexPath.row].dc_ADRES
                    cell.banka_tipi_lbl.text = bankaListModel[indexPath.row].dc_BANKA_TIPI
                    cell.banka_durum_lbl.text = bankaListModel[indexPath.row].dc_ON_OFF_LINE
                    if (bankaListModel[indexPath.row].dc_ON_OFF_LINE == "On Line"){
                        cell.cellview.layer.borderColor = UIColor.green.cgColor
                        cell.banka_durum_lbl.textColor = UIColor.green
                    }else{
                        cell.cellview.layer.borderColor = UIColor.red.cgColor
                        cell.banka_durum_lbl.textColor = UIColor.red
                    }
                    
                }
                else
                {
                    
                }
            }
            else{
                
                
                cell.sube_lbl.text = filterdata[indexPath.row].dc_BANKA_SUBE
                cell.adres_lbl.text = filterdata[indexPath.row].dc_ADRES
                cell.banka_tipi_lbl.text = filterdata[indexPath.row].dc_BANKA_TIPI
                cell.banka_durum_lbl.text = filterdata[indexPath.row].dc_ON_OFF_LINE
                if (filterdata[indexPath.row].dc_ON_OFF_LINE == "On Line"){
                    cell.cellview.layer.borderColor = UIColor.green.cgColor
                    cell.banka_durum_lbl.textColor = UIColor.green
                }else{
                    cell.cellview.layer.borderColor = UIColor.red.cgColor
                    cell.banka_durum_lbl.textColor = UIColor.red
                }
                
            }
        }
        else
        {
            cell.sube_lbl.text = bankaListModel[indexPath.row].dc_BANKA_SUBE
            cell.adres_lbl.text = bankaListModel[indexPath.row].dc_ADRES
            cell.banka_tipi_lbl.text = bankaListModel[indexPath.row].dc_BANKA_TIPI
            cell.sube_lbl.text = bankaListModel[indexPath.row].dc_BANKA_SUBE
            cell.banka_durum_lbl.text = bankaListModel[indexPath.row].dc_ON_OFF_LINE
            if (bankaListModel[indexPath.row].dc_ON_OFF_LINE == "On Line"){
                cell.cellview.layer.borderColor = UIColor.green.cgColor
                cell.banka_durum_lbl.textColor = UIColor.green
            }else{
                cell.cellview.layer.borderColor = UIColor.red.cgColor
                cell.banka_durum_lbl.textColor = UIColor.red
            }
        }
        
        cell.cellview.layer.cornerRadius=10 //set corner radius here
        // set cell border color here
        cell.cellview.layer.borderWidth = 2
        return cell
    }
    
    
    
    
    
}

extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if filterdata.count != 0 || filterEmptyControl
        {
            if filterdata.count == 0
            {
                
                if cancelControl
                {
                    let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "bankaDetayStoryboard") as! BankaDetayViewController
                    vc.bankaDetay = bankaListModel[indexPath.row]
                    vc.hidesBottomBarWhenPushed = true
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                else
                {
                    
                }
            }
            else{
                let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "bankaDetayStoryboard") as! BankaDetayViewController
                vc.bankaDetay = filterdata[indexPath.row]
                vc.hidesBottomBarWhenPushed = true
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
                
            }
        }
        else
        {
            let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "bankaDetayStoryboard") as! BankaDetayViewController
            vc.bankaDetay = bankaListModel[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
    
}

