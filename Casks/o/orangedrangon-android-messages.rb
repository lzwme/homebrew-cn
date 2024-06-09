cask "orangedrangon-android-messages" do
  version "5.4.4"
  sha256 "8ba178a15d1b48a4916263998ce5d8fe48b006f2a2784f601219bb0991d43204"

  url "https:github.comOrangeDrangonandroid-messages-desktopreleasesdownloadv#{version}Android-Messages-v#{version}-mac-universal.zip"
  name "Android Messages Desktop"
  desc "Desktop client for Android Messages"
  homepage "https:github.comOrangeDrangonandroid-messages-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "android-messages"
  depends_on macos: ">= :high_sierra"

  app "Android Messages.app"

  zap trash: "~LibraryApplication Supportandroid-messages-desktop"
end