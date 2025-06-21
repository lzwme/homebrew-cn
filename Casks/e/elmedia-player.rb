cask "elmedia-player" do
  version "8.22"
  sha256 :no_check

  url "https://cdn.electronic.us/products/elmedia/mac/download/elmediaplayer.dmg"
  name "Elmedia Player"
  desc "Video and audio player"
  homepage "https://www.electronic.us/products/elmedia/"

  livecheck do
    url "https://cdn.electronic.us/products/elmedia/mac/update/settings.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Elmedia Player.app"

  zap trash: [
    "~/Library/Application Support/Elmedia Player",
    "~/Library/Caches/com.Eltima.ElmediaPlayer",
    "~/Library/HTTPStorages/com.Eltima.ElmediaPlayer",
    "~/Library/Preferences/com.eltima.activator.xml",
    "~/Library/Preferences/com.Eltima.ElmediaPlayer.LSSharedFileList.plist",
    "~/Library/Preferences/com.Eltima.ElmediaPlayer.plist",
  ]
end