cask "picfindr" do
  version "1.6.13"
  sha256 "93c939e551036805295a59105cc479a3b8b8e522cfdff11ae6b67d85c5900144"

  url "https://ushining.softorino.com/shine_uploads/picfindr_#{version}.dmg"
  name "PicFindr"
  desc "Search engine & manager for free stock images"
  homepage "https://softorino.com/picfindr/"

  livecheck do
    url "https://ushining.softorino.com/appcast.php?abbr=pfm"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "PicFindr.app"

  zap trash: [
    "/Users/Shared/PicFindr",
    "~/Library/Application Support/PicFindr",
    "~/Library/Caches/com.softorino.picfindr",
    "~/Library/HTTPStorages/com.softorino.picfindr",
    "~/Library/HTTPStorages/com.softorino.picfindr.binarycookies",
    "~/Library/Preferences/com.softorino.picfindr.plist",
    "~/Library/Saved Application State/com.softorino.picfindr.savedState",
  ]
end