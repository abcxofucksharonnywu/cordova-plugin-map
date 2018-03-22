/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */


#import <Cordova/CDVViewController.h>
#import "CDVMap.h"
#import <GooglePlacePicker/GooglePlacePicker.h>
#import <MapKit/MapKit.h>
@interface CDVMap () {
    GMSPlacePicker*placePicker;
}
@end

@implementation CDVMap

- (void)jumpAddress:(CDVInvokedUrlCommand*)command
{
    NSDictionary *mAddress = command.arguments.firstObject;
    if(mAddress && ![mAddress isKindOfClass:[NSNull class]]){
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([mAddress[@"lat"] doubleValue],[mAddress[@"long"] doubleValue]);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:center addressDictionary:nil]];
        toLocation.name = mAddress[@"title"];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{}];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}


- (void)selectAddress:(CDVInvokedUrlCommand*)command
{
    if(!placePicker){
        GMSCoordinateBounds *viewport;
        NSDictionary *mAddress = command.arguments.firstObject;
        if(mAddress && ![mAddress isKindOfClass:[NSNull class]]){
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake([mAddress[@"lat"] doubleValue],[mAddress[@"long"] doubleValue]);
            CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude+0.001,
                                                                          center.longitude+0.001);
            CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude-0.001 ,
                                                                          center.longitude-0.001);
            viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                            coordinate:southWest];
        }
        GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
        placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    }
    [placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (place && !error) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"title":place.name,@"content":place.formattedAddress,@"lat":@(place.coordinate.latitude),@"long":@(place.coordinate.longitude)}];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}




@end
