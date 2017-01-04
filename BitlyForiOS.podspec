
Pod::Spec.new do |s|

  s.name         = "BitlyForiOS"
  s.version      = "1.4.1"
  s.summary      = "Bitly link shortener and expander."

  s.description  = <<-DESC
A Bitly link shortener which can shorten and expand URLs.
                   DESC

  s.homepage     = "https://github.com/brennanMKE/BitlyForiOS"

  s.license      = 'Apache 2'

  s.author             = { "Brennan Stehling" => "brennan@smallsharptools.com" }
  s.social_media_url = "http://twitter.com/smallsharptools"

  s.platform     = :ios, '8.4'
  s.source       = { :git => "https://github.com/brennanMKE/BitlyForiOS.git", :tag => "1.4.1" }
  s.source_files  = '**/SSTURLShortener.{h,m}'
  s.requires_arc = true

end
