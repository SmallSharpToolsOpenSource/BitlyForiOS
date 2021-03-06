Bitly for iOS
=============

<img src="https://raw.github.com/brennanMKE/BitlyForiOS/master/URLShortener.png" width="220" align="right" />

URL Shortener using Bitly

### What does it do and why?

The `SSTURLShortener` class included in this project uses the Bitly service to shorten URLs using a blocks interface in Objective-C. It makes it possible to quickly shorten any URL using this service which is especially helpful when sharing links via services like Twitter, Facebook, SMS and others where you want to keep the URL short. Another benefit is that Bitly provides analytics on click-throughs of shortened URLs. Additionally, you can use the free Bitly Pro service to use your own domain name. For SmallSharpTools (SST) which is at `smallsharptools.com` there is a shorter domain `sstools.co` which is used for sharing URLs on various platforms and to track click-throughs. For services like Twitter and SMS where messages have a hard limit a shortened URL makes room for the rest of the message. If the shortened URL is used without the additional path which identified the shortened URL it redirects to `bit.ly` by default but can go to any domain you choose.

### How to Use

Everything is in a single class named `SSTURLShortener` which you can find in the Xcode project. You can copy the header and implementation file into your Xcode project and use directly. Alternatively you coudl use `CocoaPods` or `Carthage` which are 
explained below.

The `SSTURLShortener` class has a single static method which takes the original URL, username, API key and a completion block. The username and API key come from your Bitly account. (See Legacy API Key under [Advanced Settings](https://bitly.com/a/settings/advanced)) If the same URL is shortened it may benefit from the return value already being cached as the request uses the `NSURLRequestReturnCacheDataElseLoad` caching policy.

### Testing

The included tests require user defaults to be set with the necessary access
configuration which can be set by running the demo app included in the project.
The tests can also show you how to use the URL shortener and expander.

## CocoaPods

BitlyForiOS is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "BitlyForiOS"

or

    pod 'BitlyForiOS', :git => 'https://github.com/brennanMKE/BitlyForiOS.git', :tag => '1.4'

## Carthage

Carthage is the modern alternative to CocoaPods which acts as a wrapper around the standard
`xcodebuild` command-line utility to build frameworks for iOS and OS X. See more from
[Carthage](https://github.com/Carthage/Carthage) on how to install the utility and how to
build and add frameworks to your Xcode project. Below are the configurations you can add
to your project's Cartfile. 

    github "brennanMKE/BitlyForiOS"

or

    github "brennanMKE/BitlyForiOS" "master"

The addition of `master` specifies the master branch. You can also specify a tag
or commit hash if you choose. Read more [Carthage](https://github.com/Carthage/Carthage) for configuration details.

### Sample Project

This project includes a working sample. You simply need to provide the original URL, username and API key from Bitly. After you use it the first time the values for username and API key will be stored as settings so you do not have to enter them every time. For your project you will likely use constants to provide the username and API key to the method to shorten the URL.

## License

BitlyForiOS is available under the Apache 2.0 license. See the LICENSE file for more info.

-----

Brennan Stehling  
[SmallSharpTools](http://www.smallsharptools.com/)  
[@smallsharptools](https://twitter.com/smallsharptools) (Twitter)  
