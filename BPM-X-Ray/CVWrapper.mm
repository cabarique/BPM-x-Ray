//
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVWrapper.h"
#import "UIImage+OpenCV.h"
#import "UIImage+Rotate.h"

#import "shape-detect.h"

#import "ColorPallete.h"

//#import "ColorPallete.swift"



@implementation CVWrapper


BOOL start = NO;




+ (NSArray*) detectBPM2:(UIImage*)inputImage
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    cv::Mat src = [inputImage CVMat3];
    // Convert to grayscale
    cv::Mat gray;
    cv::cvtColor(src, gray, CV_BGR2GRAY);
    
    // compute mask (you could use a simple threshold if the image is always as good as the one you provided)
    cv::Mat mask;
    cv::threshold(gray, mask, 0, 255, CV_THRESH_BINARY_INV | CV_THRESH_OTSU);

    // Use Canny instead of threshold to catch squares with gradient shading
    cv::Mat bw;
    cv::Canny(gray, bw, 0, 50, 5);
    // Find contours
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(mask,contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
    
    /// Draw contours and find biggest contour (if there are other contours in the image, we assume the biggest one is the desired rect)
    // drawing here is only for demonstration!
    int biggestContourIdx = -1;
    float biggestContourArea = 0;
    cv::Mat drawing = cv::Mat::zeros( mask.size(), CV_8UC3 );
    
    std::vector<cv::Point> approx;
    cv::Mat dst = [inputImage CVMat3];
    
    for (int i = 0; i < contours.size(); i++)
    {
        // Approximate contour with accuracy proportional
        // to the contour perimeter
        cv::approxPolyDP(cv::Mat(contours[i]), approx, cv::arcLength(cv::Mat(contours[i]), true)*0.02, true);
        
        // Skip small or non-convex objects
        if (std::fabs(cv::contourArea(contours[i])) < 100 || !cv::isContourConvex(approx))
            continue;
        
        if (approx.size() == 3)
        {
            setLabel(dst, "TRI", contours[i]);    // Triangles
        }
        else if (approx.size() >= 4 && approx.size() <= 6)
        {
            // Number of vertices of polygonal curve
            int vtc = approx.size();
            
            // Get the cosines of all corners
            std::vector<double> cos;
            for (int j = 2; j < vtc+1; j++)
                cos.push_back(angle(approx[j%vtc], approx[j-2], approx[j-1]));
            
            // Sort ascending the cosine values
            std::sort(cos.begin(), cos.end());
            
            // Get the lowest and the highest cosine
            double mincos = cos.front();
            double maxcos = cos.back();
            
            // Use the degrees obtained above and the number of vertices
            // to determine the shape of the contour
            if (vtc == 4 && mincos >= -0.1 && maxcos <= 0.3){
                setLabel(dst, "RECT", contours[i]);
                UIView* view = [self paintRect:contours[i]];
                [retVal addObject:view];
            }else if (vtc == 5 && mincos >= -0.34 && maxcos <= -0.27)
                setLabel(dst, "PENTA", contours[i]);
            else if (vtc == 6 && mincos >= -0.55 && maxcos <= -0.45)
                setLabel(dst, "HEXA", contours[i]);
        }
        else
        {
            // Detect and label circles
            double area = cv::contourArea(contours[i]);
            cv::Rect r = cv::boundingRect(contours[i]);
            int radius = r.width / 2;
            
            if (std::abs(1 - ((double)r.width / r.height)) <= 0.2 &&
                std::abs(1 - (area / (CV_PI * std::pow(radius, 2)))) <= 0.2)
                setLabel(dst, "CIR", contours[i]);
            UIView* view = [self paintCircle:contours[i]];
            [retVal addObject:view];
        }
    }
    
    UIImage* result =  [UIImage imageWithCVMat:dst];
    
    [retVal addObject:result];
    return retVal;
}


+ (NSArray*) detectBPM:(UIImage*)inputImage
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    cv::Mat src = [inputImage CVMat3];
    // Convert to grayscale
    cv::Mat gray;
    cv::cvtColor(src, gray, CV_BGR2GRAY);
    
    // Use Canny instead of threshold to catch squares with gradient shading
    cv::Mat bw;
    cv::Canny(gray, bw, 0, 50, 5);
    // Find contours
    std::vector<std::vector<cv::Point> > contours;
    cv::findContours(bw.clone(), contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
    
    std::vector<cv::Point> approx;
    cv::Mat dst = [inputImage CVMat3];

    for (int i = 0; i < contours.size(); i++)
    {
        // Approximate contour with accuracy proportional
        // to the contour perimeter
        cv::approxPolyDP(cv::Mat(contours[i]), approx, cv::arcLength(cv::Mat(contours[i]), true)*0.02, true);
        
        // Skip small or non-convex objects
        if (std::fabs(cv::contourArea(contours[i])) < 100 || !cv::isContourConvex(approx))
            continue;
        
        if (approx.size() == 3)
        {
//            setLabel(dst, "TRI", contours[i]);    // Triangles
        }
        else if (approx.size() == 2) {
            setLabel(dst, "line", contours[i]);
            UIView* view = [self paintRect:contours[i]];
            [retVal addObject:view];
        }
//        else if (approx.size() == 4) {
////            setLabel(dst, "line", contours[i]);
//            UIView* view = [self paintRect:contours[i]];
//            [retVal addObject:view];
//        }
        else if (approx.size() >= 4 && approx.size() <= 6)
        {

            // Number of vertices of polygonal curve
            int vtc = approx.size();
            
            // Get the cosines of all corners
            std::vector<double> cos;
            for (int j = 2; j < vtc+1; j++)
                cos.push_back(angle(approx[j%vtc], approx[j-2], approx[j-1]));
            
            // Sort ascending the cosine values
//            std::sort(cos.begin(), cos.end());
            
            // Get the lowest and the highest cosine
//            double mincos = cos.front();
//            double maxcos = cos.back();
//            
            // Use the degrees obtained above and the number of vertices
            // to determine the shape of the contour
            if (vtc == 4 /*&& mincos >= -0.1 && maxcos <= 0.3*/){
                setLabel(dst, "RECT", contours[i]);
                UIView* view = [self paintRect:contours[i]];
                [retVal addObject:view];
            }/*else if (vtc == 5 && mincos >= -0.34 && maxcos <= -0.27)
//                setLabel(dst, "PENTA", contours[i]);
//            else if (vtc == 6 && mincos >= -0.55 && maxcos <= -0.45)
//                setLabel(dst, "HEXA", contours[i]);*/
        }
        else
        {
            // Detect and label circles
            double area = cv::contourArea(contours[i]);
            cv::Rect r = cv::boundingRect(contours[i]);
            int radius = r.width / 2;
            
            if (std::abs(1 - ((double)r.width / r.height)) <= 0.2 &&
                std::abs(1 - (area / (CV_PI * std::pow(radius, 2)))) <= 0.2)
                setLabel(dst, "CIR", contours[i]);
                UIView* view = [self paintCircle:contours[i]];
                [retVal addObject:view];
        }
    }
    start = NO;
    
    UIImage* result =  [UIImage imageWithCVMat:dst];
    
    [retVal addObject:result];
    return retVal;
}

+(UIView*) paintCircle:(std::vector<cv::Point>&) contour {
    cv::Rect r = cv::boundingRect(contour);
    
//    ColorPalette*
    ColorPallete *pallete = [ColorPallete sharedManager];
    UIView* rect = [[UIView alloc] initWithFrame:CGRectMake(r.x, r.y, r.width, r.height) ];
    if(start == NO){
        [rect setBackgroundColor:pallete.lightRed];
        rect.layer.borderColor = pallete.darkRed.CGColor;
        start = YES;
    }else{
        [rect setBackgroundColor:pallete.lightGreen];
        rect.layer.borderColor = pallete.darkGreen.CGColor;
        
    }
    
    rect.layer.borderWidth = 4;
    rect.layer.cornerRadius = rect.frame.size.width/2;
    rect.layer.masksToBounds = YES;
    
    
    return rect;
    
}

+(UIView*) paintRect:(std::vector<cv::Point>&) contour {
    cv::Rect r = cv::boundingRect(contour);
    ColorPallete *pallete = [ColorPallete sharedManager];
    UIView* rect = [[UIView alloc] initWithFrame:CGRectMake(r.x, r.y, r.width, r.height) ];
    [rect setBackgroundColor:pallete.lightBlue];
    rect.layer.borderColor = pallete.darkBlue.CGColor;
    rect.layer.borderWidth = 4;
    rect.layer.cornerRadius = 5;

    
    return rect;

}


@end
