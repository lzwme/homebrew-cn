cask "orangedrangon-android-messages" do
  version "5.4.5"
  sha256 "24d23012e35938056919c287bb8e765385bf20eb1ab83e7d45f264e8f800a33a"

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