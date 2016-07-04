//
//  RootTableViewController.swift
//  6-2-4
//
//  Created by 田子瑶 on 16/5/26.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    private var dataSource:NSArray!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = NSArray(contentsOfURL: NSBundle.mainBundle().URLForResource("tuangou", withExtension: "plist")!)
        print(dataSource)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let content = dataSource.objectAtIndex(indexPath.row) as! NSDictionary
        
        let business = cell.viewWithTag(1) as! UILabel
        business.text = content.objectForKey("business") as? String
        
        let pic = cell.viewWithTag(2) as! UIImageView
        pic.image = UIImage(named: content.objectForKey("pic")as! String)
        
        let product = cell.viewWithTag(3) as! UILabel
        product.text = content.objectForKey("product") as? String
        
        let price = cell.viewWithTag(4) as! UILabel
        price.text = content.objectForKey("price") as? String
        
        let saleNumber = cell.viewWithTag(5) as! UILabel
//        saleNumber.text = content.objectForKey("saleNumber") as? Int
        let text = content.objectForKey("saleNumber") as? Int
        saleNumber.text = "\(text)"
        
        let productClass = cell.viewWithTag(6) as! UILabel
        productClass.text = content.objectForKey("productClass") as? String
        
        let location = cell.viewWithTag(7) as! UILabel
        location.text = content.objectForKey("location") as? String

        
        

        
        
        
        
        return cell
    }
    
    //定义ImageView（两种方式）ImageView imageView = new ImageView(this); 
    //orImageView imageView = (ImageView)this.findViewById(R.id.xxxx); 
    //or
    //通过ImageView控件显示图片（三种方式）imageView.setImageBitmap(Bitmap bm); 
    // orimageView.setImageDrawable(Drawable drawable); 
    //orimageView.setImageResource(int resId); 
    //or
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
