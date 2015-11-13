//
//  shape-detect.h
//  SwiftStitch
//
//  Created by pc on 11/12/15.
//  Copyright © 2015 ellipsis.com. All rights reserved.
//

#ifndef shape_detect_h
#define shape_detect_h

#include <opencv2/opencv.hpp>

void setLabel(cv::Mat& im, const std::string label, std::vector<cv::Point>& contour);
double angle(cv::Point pt1, cv::Point pt2, cv::Point pt0);

#endif /* shape_detect_h */
