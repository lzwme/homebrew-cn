cask "youtube-downloader" do
  version "0.12"
  sha256 "85f5ca5df1060ee32a0db6ccb9671fa8082b1e139ebb5793cc03f18c1ac24471"

  url "https:github.comDenBekeYouTube-Downloader-for-macOSreleasesdownloadv#{version}Youtube.Downloader.zip"
  name "YouTube Downloader"
  desc "Simple menu bar app to download YouTube movies"
  homepage "https:github.comDenBekeYouTube-Downloader-for-macOS"

  app "Youtube Downloader.app"

  zap trash: "~LibraryPreferencesdenbeke.Youtube-Downloader.plist"
end