//
//  ViewController.m
//  RudeAwakening
//
//  Created by Alex French on 1/4/17.
//  Copyright © 2017 Frenchal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) SPTPlaylistSnapshot *spotifyPlaylist;
@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadPlaylist];
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
        [self convertPlaylists:listPage arrayOfPlaylistSnapshots:playlist positionInListPage:0 auth:auth];
    }
}

-(void)convertPlaylists:(SPTListPage*)playlistPage arrayOfPlaylistSnapshots:(NSMutableArray*)playlist positionInListPage:(NSInteger)position auth:(SPTAuth*)auth
{
    NSLog(@"%@ my playlist items",playlistPage.items);
    
    if (playlistPage.items.count > position) {
        SPTPartialPlaylist* userPlaylist = playlistPage.items[position];
        [SPTPlaylistSnapshot playlistWithURI:userPlaylist.uri accessToken:auth.session.accessToken callback:^(NSError *error, SPTPlaylistSnapshot* playablePlaylist) {
            
            if (error != nil) {
                NSLog(@"*** Getting playlists got error: %@", error);
                return;
            }
            
            if(!playablePlaylist){
                NSLog(@"PlaylistSnapshot from call back is nil");
                return;
            }
            
            self.spotifyPlaylist = playablePlaylist;
            //[playlist addObject:playablePlaylist];
            //[self.spotifyPlaylist removeAllObjects];
            //[self.spotifyPlaylist addObjectsFromArray:playlist];
            
//            [spotifyPlaylists reloadData];
            [self collectSong:0];
        }];
    }
    else
    {
        NSLog(@"The playlist selection has failed");
    }
}

- (void)collectSong:(int) index {
    if (index < self.spotifyPlaylist.firstTrackPage.items.count) {
        self.player = [SPTAudioStreamingController sharedInstance];
        NSURL *uri = [self.spotifyPlaylist.firstTrackPage.items[index] playableUri];
        NSString *playableUri = [[NSString alloc] initWithString:[uri absoluteString]];
        
        [self.player playSpotifyURI:playableUri startingWithIndex:0 startingWithPosition:0 callback:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
