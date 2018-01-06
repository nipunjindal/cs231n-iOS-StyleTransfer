//
//  Stylize.h
//  styleTransfer
//
//  Created by njindal on 1/4/18.
//  Copyright © 2018 adobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Stylize : NSObject
+ (void)stylizeWithStyleImage: (UIImage*)styleImage andContentImage: (UIImage*)contentImage withOutputImage:(void (^)(UIImage *image))successBlock;
@end
