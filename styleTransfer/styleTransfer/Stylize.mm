//
//  Stylize.m
//  styleTransfer
//
//  Created by njindal on 1/4/18.
//  Copyright © 2018 adobe. All rights reserved.
//

#import "Stylize.h"

@implementation Stylize

+ (void)stylizeWithStyleImage: (UIImage*)styleImage andContentImage: (UIImage*)contentImage withOutputImage:(void (^)(UIImage *image))successBlock {
    
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"299e433f-72c6-1041-3ac0-eb8146ea996a" };
    NSArray *parameters = @[ @{ @"name": @"style", @"fileName": @"styleImage.jpg" },
                             @{ @"name": @"content", @"fileName": @"1.jpg" } ];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSError *error;
    NSMutableData *body = [NSMutableData data];
    for (NSDictionary *param in parameters) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        if (param[@"fileName"]) {
        } else {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", param[@"value"]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // style
    [body appendData:[@"Content-Disposition: form-data; name=\"style\"; "
                      @"filename=\"a.jpeg\"\r\n"
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n"
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(styleImage, 1)]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    // content
    
    [body appendData:[@"Content-Disposition: form-data; name=\"content\"; "
                      @"filename=\"b.jpeg\"\r\n"
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n"
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(contentImage, 1)]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://nipun-precision-t1700.corp.adobe.com:9000/stylize"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:300.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        UIImage *image = [UIImage imageWithData:data];
                                                        successBlock(image);
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}
    
@end
