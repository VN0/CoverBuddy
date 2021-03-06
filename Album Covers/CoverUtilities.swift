//
//  CoverProperties.swift
//  Album Covers
//
//  Created by Théo Arrouye on 1/10/21.
//

import Foundation
import UIKit

struct CoverProperties : Hashable {
    static let defaultAlignmentPadding : CGFloat = 100
    
    // top and bottom text
    var topText : String = "My Dope"
    var botText : String = "Playlist"
    
    // a cover is 1500 x 1500 px
    // y - position of bottom and top text
    var topPos : CGFloat = 150
    var botPos : CGFloat = 374 //1350
    
    // text alignment (.right, .center, .left)
    var topTextAlignment : NSTextAlignment = .left
    var botTextAlignment : NSTextAlignment = .left

    var topFontName : String = "Helvetica Bold"
    var botFontName : String = "Helvetica"
    
    var topFontSize : CGFloat = 216
    var botFontSize : CGFloat = 216
    
    var topFontColor : UIColor = .white
    var botFontColor : UIColor = .white
    
    var topLeftSidePadding : CGFloat = 100
    var topRightSidePadding : CGFloat = 0
    
    var botLeftSidePadding : CGFloat = 100
    var botRightSidePadding : CGFloat = 0
    
    // background image for cover
    var backgroundImgURL : String = "alexandru-acea"
    var backgroundImgType : String = "png"
    
    var dateEdited : Date?
}

func alignToInt(_ align: NSTextAlignment) -> Int16 {
    if (align == .left) {
        return 0
    }
    
    if (align == .center) {
        return 1
    }
    
    return 2
}

func intToAlign(_ num : Int16) -> NSTextAlignment {
    if (num == 0) {
        return .left
    }
    
    if (num == 1) {
        return .center
    }
    
    return .right
}

func unarchiveColor(_ colorData : NSObject?) -> UIColor {
    if (colorData != nil) {
        do {
            let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData as! Data) as! UIColor
            
            return unarchived
        } catch {
            // error unarchiving the data
        }
    }
    
    return UIColor.white // default value
}


func archiveColor(_ color : UIColor) -> NSObject? {
    do {
        let archived = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true) as NSObject
        
        return archived
    } catch {
        // error archiving the data
    }
    
    return nil
}

func PropertiesFromCover(_ cover : Cover) -> CoverProperties {
    var props = CoverProperties()
    
    props.topText = cover.topText ?? ""
    props.botText = cover.botText ?? ""
    props.topPos = CGFloat(cover.topPos)
    props.botPos = CGFloat(cover.botPos)
    props.topTextAlignment = intToAlign(cover.topTextAlignment)
    props.botTextAlignment = intToAlign(cover.botTextAlignment)
    props.topFontName = cover.topFontName ?? "Helvetica"
    props.botFontName = cover.botFontName ?? "Helvetica"
    props.topFontColor = unarchiveColor(cover.topFontColor)
    props.botFontColor = unarchiveColor(cover.botFontColor)
    props.topFontSize = CGFloat(cover.topFontSize)
    props.botFontSize = CGFloat(cover.botFontSize)
    props.topLeftSidePadding = CGFloat(cover.topLeftSidePadding)
    props.topRightSidePadding = CGFloat(cover.topRightSidePadding)
    props.botLeftSidePadding = CGFloat(cover.botLeftSidePadding)
    props.botRightSidePadding = CGFloat(cover.botRightSidePadding)
    props.backgroundImgURL = cover.backgroundImgURL ?? "adrien-converse"
    props.backgroundImgType = cover.backgroundImgType ?? "png"
    
    props.dateEdited = cover.dateEdited
    
    return props
}

func CoverFromProperties(_ props : CoverProperties) -> Cover {
    let cover = Cover(context: PersistenceController.shared.container.viewContext)
    
    cover.topText = props.topText
    cover.botText = props.botText
    cover.topPos = Float(props.topPos)
    cover.botPos = Float(props.botPos)
    cover.topTextAlignment = alignToInt(props.topTextAlignment)
    cover.botTextAlignment = alignToInt(props.botTextAlignment)
    cover.topFontName = props.topFontName
    cover.botFontName = props.botFontName
    cover.topFontColor = archiveColor(props.topFontColor)
    cover.botFontColor = archiveColor(props.botFontColor)
    cover.topFontSize = Float(props.topFontSize)
    cover.botFontSize = Float(props.botFontSize)
    cover.topLeftSidePadding = Float(props.topLeftSidePadding)
    cover.topRightSidePadding = Float(props.topRightSidePadding)
    cover.botLeftSidePadding = Float(props.botLeftSidePadding)
    cover.botRightSidePadding = Float(props.botRightSidePadding)
    cover.backgroundImgURL = props.backgroundImgURL
    cover.backgroundImgType = props.backgroundImgType
    
    cover.dateEdited = Date()
    
    return cover
}

func cgDrawCoverImage(_ image : UIImage, _ cover : CoverProperties) -> UIImage? {
    let canvas = CGSize(width: 1500, height: 1500)
    
    // Create image context with size 1500 x 1500 and scaling 1.0
    UIGraphicsBeginImageContextWithOptions(canvas, true, 1.0)
    
    // Draw background image
    image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: canvas))
    
    // Set our text attributes
    
    
    if (cover.topText != "") {
        let topTextStyle = NSMutableParagraphStyle()
        topTextStyle.alignment = cover.topTextAlignment
        
        let topFont = UIFont(name: cover.topFontName, size: cover.topFontSize) ?? UIFont.systemFont(ofSize: cover.topFontSize)
        let topTextAttributes = [
            NSAttributedString.Key.font: topFont,
            NSAttributedString.Key.paragraphStyle: topTextStyle,
            NSAttributedString.Key.foregroundColor: cover.topFontColor
        ] as [NSAttributedString.Key : Any]
    
    
        // Draw top text
        let topTextRect = CGRect(x: cover.topLeftSidePadding, y: cover.topPos - topFont.lineHeight / 2, width: canvas.width - cover.topLeftSidePadding - cover.topRightSidePadding, height: topFont.lineHeight)
        
        // Draw top string
        cover.topText.draw(in: topTextRect, withAttributes: topTextAttributes)
    }

    if (cover.botText != "") {
        
        let botTextStyle = NSMutableParagraphStyle()
        botTextStyle.alignment = cover.botTextAlignment
        
        let botFont = UIFont(name: cover.botFontName, size: cover.botFontSize) ?? UIFont.systemFont(ofSize: cover.botFontSize)
        let botTextAttributes = [
            NSAttributedString.Key.font: botFont,
            NSAttributedString.Key.paragraphStyle: botTextStyle,
            NSAttributedString.Key.foregroundColor: cover.botFontColor
        ] as [NSAttributedString.Key : Any]
        
        // Draw bottom text
        let botTextRect = CGRect(x: cover.botLeftSidePadding, y: cover.botPos - botFont.lineHeight / 2, width: canvas.width - cover.botLeftSidePadding - cover.botRightSidePadding, height: botFont.lineHeight)
        
        cover.botText.draw(in: botTextRect, withAttributes: botTextAttributes)
    }

    // Get resulting image from context
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    
    // end the image context
    UIGraphicsEndImageContext()
    
    return result
}

typealias ImageCompletionHandler = (UIImage?) -> Void

// a cover is 1500 x 1500 px
func makeCoverImage(_ cover: CoverProperties, completionHandler: @escaping ImageCompletionHandler) {
    // Load cover background image
    if let image = UIImage(named: cover.backgroundImgURL) {
        let result = cgDrawCoverImage(image, cover)
        
        // return cover image!
        completionHandler( result )
    } else {
        // couldnt load image
        completionHandler( nil )
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)


    // Resize the image
    UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
}

// a cover is 1500 x 1500 px
// a thumbnail is smallest screen dimension square px
func convertToThumbnail(_ imgMaybe : UIImage?, scaleFactor : CGFloat = 0.8) -> UIImage? {
    if let img = imgMaybe {
        let bounds = UIScreen.main.bounds
        let minsize = min(bounds.width, bounds.height)
        let newsize = ( minsize * scaleFactor ) * UIScreen.main.scale
        print("THUMBNAIL WILL BE \(minsize * scaleFactor) x \(minsize * scaleFactor) @ \(UIScreen.main.scale) (\(newsize) x \(newsize))")
        
        return resizeImage(image: img, targetSize: CGSize(width: newsize, height: newsize))
    }
    
    return nil
}

func saveCoverImage(_ cover: Cover) -> Bool {
    // try getting it from already made first
    if let imgData = cover.renderedImageData {
        if let coverImg = UIImage(data: imgData) {
            // try to write to photo album
            ImageSaver.shared.writeToPhotoAlbum(coverImg)
            return true
        }
    }
    
    // failed to get image from cover
    let alert = UIAlertController(title: "Image Export Failure", message: "Your custom cover failed to export to PNG. Please contact Support or file Feedback. We apologize for the inconvenience", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    UIApplication.shared.windows.first!.rootViewController!.present(alert, animated: true)
    
    return false
}


