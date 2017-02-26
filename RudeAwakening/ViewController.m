//
//  ViewController.m
//  RudeAwakening
//
//  Created by Alex French on 1/4/17.
//  Copyright © 2017 Frenchal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadPlaylist];
    //[myPlaylists requestNextPageWithAccessToken:<#(NSString *)#> callback:<#^(NSError *error, id object)block#>]
}

- (void)loadPlaylist{
    SPTAuth *auth = [SPTAuth defaultInstance];
    [SPTPlaylistList playlistsForUser:@"1214913146" withAccessToken:auth.session.accessToken callback:^(NSError *error, id object) {
        SPTListPage *pl = object;
        
        [self getFullPlaylistPage:pl auth:auth];
    }];
}

- (void)getFullPlaylistPage:(SPTListPage*)listPage auth:(SPTAuth*)auth {
    if (listPage.hasNextPage) {
        [listPage requestNextPageWithAccessToken:auth.session.accessToken callback:^(NSError *error, SPTListPage* playlistPage) {
        if (error != nil) {
            NSLog(@"*** Getting playlist page got error: %@", error);
            return;
        }
        
        SPTListPage *newListPage = [listPage pageByAppendingPage:playlistPage];
            [self getFullPlaylistPage:newListPage auth:auth];
    }];
    } else {
        
        NSMutableArray* playlist = [[NSMutableArray alloc]init];
        [self convertPlaylists:listPage arrayOfPlaylistSnapshots:playlist positionInListPage:0];
        //[self collectSong:listPage];
    }
}

-(void)convertPlaylists:(SPTListPage*)playlistPage arrayOfPlaylistSnapshots:(NSMutableArray*)playlist positionInListPage:(NSInteger)position
{
    NSLog(@"%@ my playlist items",playlistPage.items);
}

- (void)collectSong:(SPTListPage*)listPage {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
