cask "youtube-downloader" do
  version "0.16"
  sha256 "0f6c5205b7e86c1bff5bacd8ac2b8f247e443cea8c69ce07b52c9436d60d956b"

  url "https:github.comDenBekeYouTube-Downloader-for-macOSreleasesdownloadv#{version}Youtube.Downloader.zip"
  name "YouTube Downloader"
  desc "Simple menu bar app to download YouTube movies"
  homepage "https:github.comDenBekeYouTube-Downloader-for-macOS"

  depends_on macos: ">= :sierra"

  app "Youtube Downloader.app"

  zap trash: "~LibraryPreferencesdenbeke.Youtube-Downloader.plist"
end