//
//  AccountController.swift
//  movieApp
//
//  Created by Adis Cehajic on 27/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

import UIKit
//import Charts
class AccountController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource{
    
    @IBOutlet weak var graphView: BEMSimpleLineGraphView!
    @IBOutlet weak var logButton: UIButton!
    var realm: RLMRealm!
    var accmovie: MOVMovie!
    var movies:[Int:Int] = [0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0];
    var visitedMovies=[MOVMovie]()
    var i:CGFloat = 2.3
    var gradient:CGGradient?
    func registerAsObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"movieViewed", object:nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieAdd:", name:"movieViewed", object: nil)
        
    }
/*

- (void) detailsegue:(NSString *)movietitle
{
RLMArray<MOVRealmMovie*><MOVRealmMovie> *movs= [MOVRealmMovie allObjects];
for (int i=0; i<movs.count; i++)
{
if([[[movs objectAtIndex:i] title] isEqualToString:movietitle])
{
self.movie=[[MOVMovie alloc] initWithRLMObject:[movs objectAtIndex:i]];
// controller.movie=[[MOVMovie alloc] initWithRLMObject:[movs objectAtIndex:i]];
[self performSegueWithIdentifier:@"showDetail" sender:self];
break;
}
}
}

*/
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "detailSegue") {
              let viewController:MOVDetailController = segue!.destinationViewController as!MOVDetailController
            viewController.movie=accmovie;
        }
    }
    func detailsegue(movietitle:String)
    {
        let movs=MOVRealmMovie.allObjects();
        for (var i=0; UInt(i)<movs.count; i++)
        {
            if(MOVRealmMovie(value: movs.objectAtIndex(UInt(i))).title==movietitle)
            {
                accmovie=MOVMovie(RLMObject: MOVRealmMovie(value: movs.objectAtIndex(UInt(i))));
                performSegueWithIdentifier("detailSegue", sender: self);
            }
        }
    }
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 7;
    }
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        if movies.count>0 {
            return CGFloat(movies[index+1]!);}
        else{
            return 0;}
    }
    public func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        switch index{
        case 0: return "Sun";
        case 1: return "Mon";
        case 2: return "Tue";
        case 3: return "Wed";
        case 4: return "Thu";
        case 5: return "Fri";
        case 6: return "Sat";
        default: return "Sat";
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if loggedIn==false
        {
            //loggedIn=true;
            performSegueWithIdentifier("loginSegue", sender: nil)
        }
        else
        {
            logButton.setTitle("Log In", forState: UIControlState.Normal)
            loggedIn=false;
            NSNotificationCenter.defaultCenter().postNotificationName("LoggedOut", object: nil)
        }

    }
   
    var loggedIn: Bool = false
    func loginChange(notification: NSNotification){
        loggedIn=true;
    }
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginChange:", name:"LogInSuccessful", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "LogInOut:",
            name: "LoggedIn",
            object: nil)
       graphView.reloadGraph();
        // Draw an average line
        graphView.averageLine.enableAverageLine = true;
        graphView.averageLine.alpha = 0.6;
        graphView.averageLine.color = UIColor(
            red:0.0,
            green:0.0,
            blue:0.0,
            alpha:1.0);
        graphView.averageLine.width = 2;
        graphView.enableTouchReport = true;
        graphView.enablePopUpReport = true;
        graphView.enableYAxisLabel = true;
        graphView.autoScaleYAxis = true;
        graphView.alwaysDisplayDots = true;
        graphView.enableReferenceXAxisLines = true;
        graphView.enableReferenceYAxisLines = true;
        graphView.enableReferenceAxisFrame = true;
        graphView.averageLine.dashPattern=[(2),(2)];
        // Set the graph's animation style to draw, fade, or none
        graphView.animationGraphStyle = BEMLineAnimation.Draw;
        graphView.lineDashPatternForReferenceYAxisLines = [(2),(2)];
        var color = UIColor(red:0.0, green:140.0/255.0, blue:255.0/255.0, alpha:1.0);
        graphView.colorTop = color;
        graphView.colorBottom = color;
        graphView.backgroundColor = color;
        // Dash the y reference lines
       // Show the y axis values with this format string
       graphView.formatStringForValues = "%.0f";
        let colorspace = CGColorSpaceCreateDeviceRGB();
        let num_locations:size_t = 2;
        let locations:[CGFloat]=[ 0.0, 1.0 ];
        let components:[CGFloat] = [
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 0.0
        ];
        gradient=CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        graphView.gradientBottom=gradient!;
        graphView.enableBezierCurve=false;
          }
    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 2;
    }
    func movieAdd(notification:NSNotification){
        /*let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .WeekOfYear, .Weekday, .Day, .Month, .Year], fromDate: date)
        if components.weekOfYear == notification.userInfo!["weekOfYear"] as! Int
        {
            var val=movies[(notification.userInfo!["weekday"] as? Int)!];
            val=val!+1;
            var oldVal = movies.updateValue(val!, forKey: (notification.userInfo!["weekday"] as? Int)!)
            if ((graphView) != nil) {graphView.reloadGraph()};
        }*/
        
    }
    func LogInOut(notification: NSNotification){
        if loggedIn==false
        {
            logButton.setTitle("Log In", forState: UIControlState.Normal)
        }
        else
        {
            logButton.setTitle("Log Out", forState: UIControlState.Normal)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        realm = RLMRealm.defaultRealm()
        let arr=MOVRealmVisitedMovie.allObjects();
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .WeekOfYear, .Weekday, .Day, .Month, .Year], fromDate: NSDate())
        for var i = 0; UInt(i) < arr.count; i++ {
                    var components2=calendar.components([.Hour, .Minute, .WeekOfYear, .Weekday, .Day, .Month, .Year], fromDate:MOVRealmVisitedMovie(value: arr.objectAtIndex(UInt(i))).lastVisited)
            
            var exists=false;
            if components.weekOfYear == components2.weekOfYear
            {
                for var j=0; j<visitedMovies.count; j++
                {
                    if(visitedMovies[j].title==arr[UInt(i)].title) {exists=true; break;}
                }
                if !exists
                {
                visitedMovies.append(MOVMovie.init(RLMVisitedObject: MOVRealmVisitedMovie(value: arr.objectAtIndex(UInt(i)))));
                var val=movies[(components2.weekday)];
                val=val!+1;
                var oldVal = movies.updateValue(val!, forKey: components2.weekday)
                }
        
            }
            
        }
        graphView.reloadGraph();
        
        if loggedIn==true
        {
           logButton.setTitle("Log Out", forState: UIControlState.Normal)
        }
        else
        {
            logButton.setTitle("Log In", forState: UIControlState.Normal)
            
        }
        
    }
}


