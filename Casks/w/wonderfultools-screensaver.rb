cask "wonderfultools-screensaver" do
  version "1.0"
  sha256 :no_check

  url "https:github.comaidev1065Wonderful-Tools-ScreensaverrawmasterWonderfulTools.saver.zip"
  name "Wonderful Tools Screensaver"
  desc "Screensaver based on opening video from Apple's September 2019 event"
  homepage "https:github.comaidev1065Wonderful-Tools-Screensaver"

  disable! date: "2024-12-16", because: :discontinued

  screen_saver "WonderfulTools.saver"

  zap trash: "~LibraryCachesWonderfulTools"
end