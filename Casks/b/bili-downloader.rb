cask "bili-downloader" do
  version "1.7.2"
  sha256 "aacc58eb79d64437b15882502190be17e68656999af6efcc81fa831973115bfa"

  url "https:github.comJimmyLiang-lzmbiliDownloader_GUIreleasesdownloadV#{version}BiliDownloader_for_MacOS_X.dmg"
  name "BiliDownloader"
  desc "BiliBili media downloader"
  homepage "https:github.comJimmyLiang-lzmbiliDownloader_GUI"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "biliDownloader_GUI.app"

  zap trash: "~LibrarySaved Application StatebiliDownloader_GUI.savedState"
end