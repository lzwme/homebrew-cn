cask "orangedrangon-android-messages" do
  version "5.6.0"
  sha256 "e485289b409c2d2a15439c9e023f4d99baa657b2903cef1f23b65ba1272d4a30"

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