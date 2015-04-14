//
//  UIImage+Logos.m
//  Usernames
//
//  Created by Zachary Shakked on 3/24/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "UIImage+Logos.h"

@implementation UIImage (Logos)

+ (UIImage *)logoForNetwork:(NSString *)network {
    UIImage *logo;
    if ([network isEqualToString:@"Instagram"]) {
        logo = [UIImage imageNamed:@"instagram.png"];
    } else if ([network isEqualToString:@"Github"]) {
        logo = [UIImage imageNamed:@"github.png"];
    } else if ([network isEqualToString:@"Pinterest"]) {
        logo = [UIImage imageNamed:@"pinterest.png"];
    } else if ([network isEqualToString:@"Twitter"]) {
        logo = [UIImage imageNamed:@"twitter.png"];
    } else if ([network isEqualToString:@"Tumblr"]) {
        logo = [UIImage imageNamed:@"tumblr.png"];
    } else if ([network isEqualToString:@"Ebay"]) {
        logo = [UIImage imageNamed:@"ebay.png"];
    } else if ([network isEqualToString:@"Dribbble"]) {
        logo = [UIImage imageNamed:@"dribbble.png"];
    } else if ([network isEqualToString:@"Behance"]) {
        logo = [UIImage imageNamed:@"behance.png"];
    } else if ([network isEqualToString:@"Youtube"]) {
        logo = [UIImage imageNamed:@"youtube.png"];
    } else if ([network isEqualToString:@"GooglePlus"]) {
        logo = [UIImage imageNamed:@"googleplus.png"];
    } else if ([network isEqualToString:@"Reddit"]) {
        logo = [UIImage imageNamed:@"reddit.png"];
    } else if ([network isEqualToString:@"Imgur"]) {
        logo = [UIImage imageNamed:@"imgur.png"];
    } else if ([network isEqualToString:@"Wordpress"]) {
        logo = [UIImage imageNamed:@"wordpress.png"];
    } else if ([network isEqualToString:@"Gravatar"]) {
        logo = [UIImage imageNamed:@"gravatar.jpg"];
    } else if ([network isEqualToString:@"EtsyShop"]) {
        logo = [UIImage imageNamed:@"etsy.png"];
    } else if ([network isEqualToString:@"EtsyPeople"]) {
        logo = [UIImage imageNamed:@"etsy.png"];
    } else if ([network isEqualToString:@"AboutMe"]) {
        logo = [UIImage imageNamed:@"aboutme.png"];
    } else if ([network isEqualToString:@"KickAssTo"]) {
        logo = [UIImage imageNamed:@"kickasstorrents.png"];
    } else if ([network isEqualToString:@"ThePirateBay"]) {
        logo = [UIImage imageNamed:@"piratebay.png"];
    } else if ([network isEqualToString:@"Flickr"]) {
        logo = [UIImage imageNamed:@"flickr.png"];
    } else if ([network isEqualToString:@"DeviantArt"]) {
        logo = [UIImage imageNamed:@"deviantart.png"];
    } else if ([network isEqualToString:@"Twitch"]) {
        logo = [UIImage imageNamed:@"Twitch.png"];
    } else if ([network isEqualToString:@"Vimeo"]) {
        logo = [UIImage imageNamed:@"vimeo.png"];
    } else if ([network isEqualToString:@"LifeHacker"]) {
        logo = [UIImage imageNamed:@"lifehacker.png"];
    } else if ([network isEqualToString:@"WikiAnswers"]) {
        logo = [UIImage imageNamed:@"WikipediaW.png"];
    } else if ([network isEqualToString:@"SoundCloud"]) {
        logo = [UIImage imageNamed:@"soundcloud.png"];
    } else if ([network isEqualToString:@"IGN"]) {
        logo = [UIImage imageNamed:@"ign.jpg"];
    } else if ([network isEqualToString:@"OkCupid"]) {
        logo = [UIImage imageNamed:@"okcupid.png"];
    } else if ([network isEqualToString:@"TheVerge"]) {
        logo = [UIImage imageNamed:@"verge.png"];
    } else if ([network isEqualToString:@"KickStarter"]) {
        logo = [UIImage imageNamed:@"kickstarter.png"];
    } else if ([network isEqualToString:@"Spotify"]) {
        logo = [UIImage imageNamed:@"spotify.png"];
    } else if ([network isEqualToString:@"Alibaba"]) {
        logo = [UIImage imageNamed:@"Alibaba.png"];
    } else if ([network isEqualToString:@"Aviary"]) {
        logo = [UIImage imageNamed:@"Aviary.png"];
    } else {
        logo = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", network]];
    }
    return logo;
}

@end
