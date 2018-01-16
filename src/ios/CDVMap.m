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
@interface CDVMap () {
    CDVInvokedUrlCommand *_command;
}
@end

@implementation CDVMap
-(void)pluginInitialize{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMap:) name:@"map" object:nil];
}

-(void)handleMap:(NSNotification*)ns{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ns.userInfo[@"content"]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
}


- (void)jumpAddress:(CDVInvokedUrlCommand*)command
{
    _command = command;
}


- (void)selectAddress:(CDVInvokedUrlCommand*)command
{
    _command = command;
}



- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
