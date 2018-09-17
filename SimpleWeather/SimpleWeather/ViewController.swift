//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Lu Yunchi on 2018/9/12.
//  Copyright © 2018年 Lu Yunchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //variables********************
    var wendu:UILabel!
    var tdremain1:UILabel!
    var tdremain2:UILabel!
    var tdiconimgv:UIImageView!
    var labeltype:UILabel!
    var success:Bool=true
    var citylabel:UILabel!
    var city:String="北京"
    var aler=UIAlertController(title: "", message: "", preferredStyle: .alert)
    var width:CGFloat!
    var height:CGFloat!
    var icondic:[String:UIImage]=["晴":#imageLiteral(resourceName: "Layer 0003 (qing).png") ,"多云": #imageLiteral(resourceName: "Layer 0005 (duoyun).png"),"阴": #imageLiteral(resourceName: "Layer 0007 (yin).png"),"大雨":#imageLiteral(resourceName: "Layer 0011 (dayu).png") ,"暴雨":#imageLiteral(resourceName: "Layer 0013 (baoyu).png") ,"阵雨":#imageLiteral(resourceName: "Layer 0015 (leizhenyu).png") ,"温度":#imageLiteral(resourceName: "Layer 0017 (wendu).png"),"风向":#imageLiteral(resourceName: "Layer 0019 (fengxiang).png") ,"湿度":#imageLiteral(resourceName: "Layer 0021 (shidu).png") ,"中雨":#imageLiteral(resourceName: "Layer 0011 (dayu).png"),"小雨":#imageLiteral(resourceName: "Layer 0011 (dayu).png"),"雷阵雨":#imageLiteral(resourceName: "Layer 0015 (leizhenyu).png")]
    var tdicondic:[String:UIImage]=["晴": #imageLiteral(resourceName: "q.png"),"多云":#imageLiteral(resourceName: "duoyun.png") ,"阴":#imageLiteral(resourceName: "y.png") ,"大雨": #imageLiteral(resourceName: "dyu.png"),"暴雨": #imageLiteral(resourceName: "byu.png"),"阵雨":#imageLiteral(resourceName: "lzyu.png"),"温度":#imageLiteral(resourceName: "wd.png"),"风向": #imageLiteral(resourceName: "fx.png"),"湿度":#imageLiteral(resourceName: "sd.png") ,"中雨":#imageLiteral(resourceName: "dyu.png"),"小雨":#imageLiteral(resourceName: "dyu.png"),"雷阵雨":#imageLiteral(resourceName: "lzyu.png")]
    var date="00000000"
    struct weather{
        var date:String=""
        var pm25:Int=0
        var pm10:Int=0
        var aqi:Int=0
        var wendu:String=""
        var type:String=""
        var fx:String=""
        var fl:String=""
        var shidu:String=""
        var sunrise:String=""
        var sunset:String=""
        var high:String=""
        var low:String=""
    }
    var today=weather()
    var forecast=[weather]()
    var todayview:UIView!
    var forecastview:UITableView!
    //viewdidload*******************
    override func viewDidLoad() {
        super.viewDidLoad()
        let mvimgv=UIImageView(frame: self.view.frame)
        mvimgv.image=#imageLiteral(resourceName: "white.png")
        self.view.addSubview(mvimgv)
        self.view.sendSubview(toBack: mvimgv)
        width=self.view.frame.width
        height=self.view.frame.height
        loadjason()
        //todayview
        todayview=UIView(frame: CGRect(x: 0.05*width, y: 0.12*height, width: 0.9*width, height: 0.32*height))
        self.view.addSubview(todayview)
        let tdimgv=UIImageView(frame: CGRect(x: 0, y: 0, width: 0.9*width, height: 0.4*height))
        tdimgv.image=#imageLiteral(resourceName: "black.png")
        todayview.sendSubview(toBack: tdimgv)
        todayview.layer.cornerRadius=20
        todayview.layer.masksToBounds=true
        todayview.addSubview(tdimgv)
        wendu=UILabel(frame:CGRect(x: 0.45*width, y: 0.02*height, width: 0.4*width, height: 0.14*height))
        wendu.text=today.wendu + "℃"
        wendu.textColor=UIColor.white
        wendu.font=UIFont(name: "FZJinLS-L-GB", size: 70)
        wendu.textAlignment = .right
        todayview.addSubview(wendu)
        todayview.bringSubview(toFront: wendu)
        let tdremain0=UILabel(frame:CGRect(x: 0.45*width, y:0.16*height, width: 0.4*width, height: 0.03*height))
        tdremain0.text="\(date.prefix(4))年\(date.prefix(6).suffix(2))月\(date.suffix(2))日"
        tdremain0.textAlignment = .right
        tdremain0.font=UIFont(name: "FZJinLS-L-GB", size: 18)
        tdremain0.textColor=UIColor.white
        todayview.addSubview(tdremain0)
        todayview.bringSubview(toFront: tdremain0)
        tdremain1=UILabel(frame:CGRect(x: 0.6*width, y:0.21*height, width: 0.25*width, height: 0.03*height))
        tdremain1.text="湿度 : \(today.shidu)"
        tdremain1.textAlignment = .right
        tdremain1.font=UIFont(name: "FZJinLS-L-GB", size: 18)
        tdremain1.textColor=UIColor.white
        todayview.addSubview(tdremain1)
        todayview.bringSubview(toFront: tdremain1)
        let shiduimgv = UIImageView(frame:CGRect(x: 0.55*width, y:0.225*height-0.025*width, width: 0.05*width, height: 0.05*width))
        shiduimgv.image=icondic["湿度"]
        todayview.addSubview(shiduimgv)
        tdremain2=UILabel(frame:CGRect(x: 0.45*width-0.4*width, y:0.26*height, width: 0.8*width, height: 0.03*height))
        tdremain2.text="风:"+forecast[0].fx+forecast[0].fl
        tdremain2.textAlignment = .right
        tdremain2.font=UIFont(name: "FZJinLS-L-GB", size: 18)
        tdremain2.textColor=UIColor.white
        tdiconimgv=UIImageView(frame: CGRect(x: 0.1*width, y: 0.06*width, width: 0.3*width, height: 0.3*width))
        tdiconimgv.image=tdicondic[forecast[0].type]
        labeltype=UILabel(frame: CGRect(x: 0.02*width, y: 0.4*width, width: 0.5*width, height: 0.04*height))
        labeltype.text=forecast[0].type
        labeltype.textAlignment = .center
        labeltype.font=UIFont(name: "FZJinLS-L-GB", size: 30)
        labeltype.textColor=UIColor.white
        todayview.addSubview(labeltype)
        todayview.addSubview(tdiconimgv)
        todayview.addSubview(tdremain2)
        todayview.bringSubview(toFront: tdremain2)
        //*******************************
        let rec=UILabel(frame: CGRect(x: 0.47*width, y: 0.46*height, width: 0.06*width, height: 0.06*width))
        rec.text="▽"
        rec.font=UIFont(name: "FZJinLS-L-GB", size: 20)
        rec.textColor=UIColor.black
        self.view.addSubview(rec)
        citylabel=UILabel(frame: CGRect(x: 0.40*width, y: 0.06*height, width: 0.2*width, height: 0.06*width))
        citylabel.text=city
        citylabel.textAlignment = .center
        citylabel.font=UIFont(name: "FZJinLS-L-GB", size: 24)
        citylabel.textColor=UIColor.black
        self.view.addSubview(citylabel)
        let pbut=UIButton(frame: CGRect(x: 0.05*width, y: 0.06*height, width: 20, height: 20))
        pbut.setTitle("+", for: .normal)
        pbut.setTitleColor(UIColor.black, for: .normal)
        pbut.titleLabel?.font=UIFont(name: "FZJinLS-L-GB", size: 40)
        pbut.addTarget(self, action: #selector(butac), for: .touchUpInside)
        self.view.addSubview(pbut)
        //forecastview*******************************
        forecastview=UITableView(frame: CGRect(x: 0, y: 0.5*height, width: width, height: 0.55*height))
        forecastview.delegate=self
        forecastview.dataSource=self
        forecastview.backgroundColor=UIColor.clear
        forecastview.separatorStyle = .none
        self.view.addSubview(forecastview)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forecastview.reloadData()
        let cells=forecastview.visibleCells
        for (index,cell) in cells.enumerated(){
            cell.frame.origin.y=self.view.frame.height
            UIView.animate(withDuration: 0.8, delay: 0.1*Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations:{cell.frame.origin.y=0.5*self.height}, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}





extension ViewController:UITableViewDelegate,UITableViewDataSource{
    @objc func butac(){
        let askwindow=UIAlertController(title: "输入城市", message: nil, preferredStyle: .alert)
        askwindow.addTextField{(tf:UITextField!) -> Void in
            tf.placeholder = "城市"
        }
        let cancel=UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let ok=UIAlertAction(title: "确定", style: .default){
            action in
            self.city=askwindow.textFields!.first!.text!
            self.loadjason()
            //print("OK",self.success)
            guard(self.success)else{
                self.aler.title="匹配错误"
                self.aler.message="请重新输入城市"
                self.showaler()
                return}
            self.citylabel.text=self.city
            self.wendu.text=self.today.wendu + "℃"
            self.tdremain1.text="湿度 : \(self.today.shidu)"
            self.tdremain2.text="风:"+self.forecast[0].fx+self.forecast[0].fl
            self.self.tdiconimgv.image=self.tdicondic[self.forecast[0].type]
            self.labeltype.text=self.forecast[0].type
            self.forecastview.reloadData()
        }
        askwindow.addAction(cancel)
        askwindow.addAction(ok)
        self.present(askwindow, animated: true, completion: nil)
        
    }
    func showaler(){
        self.present(aler, animated: true, completion: nil)
        let disstime=Timer.scheduledTimer(withTimeInterval: 3, repeats: false){(Timer) in
            self.dismiss(animated: true, completion: nil)
        }
        RunLoop.main.add(disstime, forMode: .commonModes)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.16*height
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let info=UITableViewRowAction(style: .normal, title: "more"){action,index  in
            self.aler.message="  \n日升:\(self.forecast[indexPath.row].sunrise)\n日落:\(self.forecast[indexPath.row].sunset)\nAQI:\(self.forecast[indexPath.row].aqi)"
            self.aler.title="天气信息"
            self.showaler()
        }
        info.backgroundColor=UIColor.clear

        return[info]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell()
        cell.backgroundColor=UIColor.clear
        let view=UIView(frame: CGRect(x: 0.05*width, y: 0.01*height, width: 0.9*width, height: 0.14*height))
        view.layer.borderColor=UIColor.black.cgColor
        view.layer.borderWidth=1.5
        view.layer.cornerRadius=15
        let imgv=UIImageView(frame: CGRect(x: 0.025*height, y: 0.01*height, width: 0.08*height, height: 0.08*height))
        imgv.image=icondic[forecast[indexPath.row+1].type]
        let labeltype=UILabel(frame: CGRect(x: 0.017*height, y: 0.09*height, width: 0.1*height, height: 0.04*height))
        labeltype.text=forecast[indexPath.row+1].type
        labeltype.textAlignment = .center
        labeltype.font=UIFont(name: "FZJinLS-L-GB", size: 18)
        let labeldate=UILabel(frame: CGRect(x: 0.22*width, y: 0.01*height, width: 0.5*width, height: 0.04*height))
        labeldate.text=forecast[indexPath.row+1].date
        labeldate.textAlignment = .left
        labeldate.font=UIFont(name: "FZJinLS-L-GB", size: 28)
        let labelhigh=UILabel(frame: CGRect(x: 0.22*width, y: 0.05*height, width: 0.35*width, height: 0.04*height))
        labelhigh.text="最高: "+forecast[indexPath.row+1].high.suffix(from: forecast[indexPath.row].high.index(forecast[indexPath.row+1].high.startIndex, offsetBy: 3))
        labelhigh.textAlignment = .left
        labelhigh.font=UIFont(name: "FZJinLS-L-GB", size: 20)
        let labellow=UILabel(frame: CGRect(x: 0.22*width, y: 0.09*height, width: 0.35*width, height: 0.04*height))
        labellow.text="最低: "+forecast[indexPath.row+1].low.suffix(from: forecast[indexPath.row].low.index(forecast[indexPath.row+1].low.startIndex, offsetBy: 3))
        labellow.textAlignment = .left
        labellow.font=UIFont(name: "FZJinLS-L-GB", size: 20)
        let labelfx=UILabel(frame: CGRect(x: 0.6*width, y: 0.05*height, width: 0.3*width, height: 0.04*height))
        labelfx.text="风向: "+forecast[indexPath.row+1].fx
        labelfx.textAlignment = .left
        labelfx.font=UIFont(name: "FZJinLS-L-GB", size: 20)
        let labelfl=UILabel(frame: CGRect(x: 0.6*width, y: 0.09*height, width: 0.3*width, height: 0.04*height))
        labelfl.text="风力: "+forecast[indexPath.row+1].fl
        labelfl.textAlignment = .left
        labelfl.font=UIFont(name: "FZJinLS-L-GB", size: 20)
        
        
        view.addSubview(labelfl)
        view.addSubview(labelfx)
        view.addSubview(labellow)
        view.addSubview(labelhigh)
        view.addSubview(labeldate)
        view.addSubview(labeltype)
        view.addSubview(imgv)
        cell.addSubview(view)
        return cell
    }
    
    func loadjason(){
        do{
            let string="https://www.sojson.com/open/api/weather/json.shtml?city="+self.city
            let urlEncodeString = string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = NSURL(string: urlEncodeString!)
            let jsondata = try Data(contentsOf: url! as URL)
            /*let jsondata="""
                {
                "date": "20180914",
                "message": "Success !",
                "status": 200,
                "city": "北京",
                "count": 4,
                "data": {
                    "shidu": "85%",
                    "pm25": 103,
                    "pm10": 126,
                    "quality": "轻度污染",
                    "wendu": "20",
                    "ganmao": "儿童、老年人及心脏、呼吸系统疾病患者人群应减少长时间或高强度户外锻炼",
                    "yesterday": {
                        "date": "13日星期四",
                        "sunrise": "05:52",
                        "high": "高温 29.0℃",
                        "low": "低温 20.0℃",
                        "sunset": "18:28",
                        "aqi": 120,
                        "fx": "南风",
                        "fl": "<3级",
                        "type": "多云",
                        "notice": "阴晴之间，谨防紫外线侵扰"
                    },
                    "forecast": [
                    {
                    "date": "14日星期五",
                    "sunrise": "05:53",
                    "high": "高温 28.0℃",
                    "low": "低温 19.0℃",
                    "sunset": "18:27",
                    "aqi": 138,
                    "fx": "南风",
                    "fl": "<3级",
                    "type": "小雨",
                    "notice": "雨虽小，注意保暖别感冒"
                    },
                    {
                    "date": "15日星期六",
                    "sunrise": "05:53",
                    "high": "高温 27.0℃",
                    "low": "低温 17.0℃",
                    "sunset": "18:25",
                    "aqi": 49,
                    "fx": "北风",
                    "fl": "3-4级",
                    "type": "多云",
                    "notice": "阴晴之间，谨防紫外线侵扰"
                    },
                    {
                    "date": "16日星期日",
                    "sunrise": "05:54",
                    "high": "高温 26.0℃",
                    "low": "低温 15.0℃",
                    "sunset": "18:23",
                    "aqi": 67,
                    "fx": "北风",
                    "fl": "<3级",
                    "type": "多云",
                    "notice": "阴晴之间，谨防紫外线侵扰"
                    },
                    {
                    "date": "17日星期一",
                    "sunrise": "05:55",
                    "high": "高温 27.0℃",
                    "low": "低温 18.0℃",
                    "sunset": "18:22",
                    "aqi": 58,
                    "fx": "北风",
                    "fl": "<3级",
                    "type": "多云",
                    "notice": "阴晴之间，谨防紫外线侵扰"
                    },
                    {
                    "date": "18日星期二",
                    "sunrise": "05:56",
                    "high": "高温 24.0℃",
                    "low": "低温 16.0℃",
                    "sunset": "18:20",
                    "aqi": 67,
                    "fx": "西南风",
                    "fl": "<3级",
                    "type": "阴",
                    "notice": "不要被阴云遮挡住好心情"
                    }
                    ]
                }
            }
""".data(using: .utf8)!*/
            var json = try JSONSerialization.jsonObject(with: jsondata as Data, options: JSONSerialization.ReadingOptions.allowFragments)as! [String:AnyObject]
            //print(json)
            guard(json["message"]as!String != "Check the parameters.")else{
                self.success=false
                return
            }
            self.success=true
            let jsontoday=json["data"]
            let jsonforecast=jsontoday!["forecast"] as! NSArray
            date=json["date"] as! String
            today.shidu=jsontoday!["shidu"] as! String
            today.wendu=jsontoday!["wendu"] as! String
            //today.pm25=jsontoday!["pm25"] as! Int
            //today.pm10=jsontoday!["pm10"] as! Int
            
            
            for i in 0..<5{
                let tempt=jsonforecast[i] as! NSDictionary
                forecast.append(weather())
                forecast[i].high=tempt["high"] as! String
                forecast[i].low=tempt["low"] as! String
                forecast[i].sunrise=tempt["sunrise"] as! String
                forecast[i].sunset=tempt["sunset"] as! String
                forecast[i].aqi=tempt["aqi"] as! Int
                forecast[i].fx=tempt["fx"] as! String
                forecast[i].fl=tempt["fl"] as! String
                forecast[i].type=tempt["type"] as! String
                forecast[i].date=tempt["date"] as! String
            }
        }catch _ as NSError{}
    }
    
    
}
