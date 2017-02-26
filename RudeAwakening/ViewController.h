//
//  ViewController.h
//  RudeAwakening
//
//  Created by Alex French on 1/4/17.
//  Copyright © 2017 Frenchal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyMetadata/SPTPlaylistList.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) SPTListPage *userPlaylists;

@end

