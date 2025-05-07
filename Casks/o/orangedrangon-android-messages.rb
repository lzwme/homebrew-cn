cask "orangedrangon-android-messages" do
  version "5.7.1"
  sha256 "7680578ba10c6d254c43180eee3d2f0c1302a8ec4553d46d692ad265098d2c6d"

  url "https:github.comOrangeDrangonandroid-messages-desktopreleasesdownloadv#{version}Android-Messages-v#{version}-mac-universal.zip"
  name "Android Messages Desktop"
  desc "Desktop client for Android Messages"
  homepage "https:github.comOrangeDrangonandroid-messages-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "android-messages"
  depends_on macos: ">= :big_sur"

  app "Android Messages.app"

  zap trash: "~LibraryApplication Supportandroid-messages-desktop"
end