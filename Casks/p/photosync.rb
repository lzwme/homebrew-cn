cask "photosync" do
  version "4.2"
  sha256 "20e6e268697a0b8b3841ed30b12e738cdb0a6452b86537dfa258793bbf65d63d"

  url "https://download.photosync-app.com/mac/photosync_#{version.dots_to_underscores}.zip"
  name "PhotoSync Companion"
  desc "Transfer and backup photos and videos"
  homepage "https://www.photosync-app.com/home.html"

  livecheck do
    url "https://download.photosync-app.com/xml/photosyncmac-updates-standalone.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  app "PhotoSync.app"

  zap trash: [
    "~/Library/Application Support/com.touchbyte.mac.PhotoSync",
    "~/Library/Caches/com.touchbyte.mac.PhotoSync",
    "~/Library/HTTPStorages/com.touchbyte.mac.PhotoSync",
    "~/Library/Preferences/com.touchbyte.mac.PhotoSync.plist",
    "~/Library/Saved Application State/com.touchbyte.mac.PhotoSync.savedState",
  ]
end