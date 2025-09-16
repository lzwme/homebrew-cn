cask "mitti" do
  version "2.8.14,1373"
  sha256 "696222c0902119b97972020f44b64a7665cff812b23c0116e5be0c7db3be0fba"

  url "https://dl.imimot.com/Mitti#{version.csv.first}_#{version.csv.second}.dmg"
  name "Mitti"
  desc "Video playback software"
  homepage "https://imimot.com/mitti/"

  livecheck do
    url "https://imimot.com/versions/MittiAppcast_v2.php?beta=0&product=mitti#{version.major}&app_version=0"
    strategy :sparkle
  end

  auto_updates true

  app "Mitti.app"

  zap trash: [
    "~/Library/Application Scripts/com.imimot.Mitti.*.MittiQuicklook",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.imimot.mitti.*.sfl*",
    "~/Library/Application Support/Mitti",
    "~/Library/Containers/com.imimot.Mitti.*.MittiQuicklook",
    "~/Library/HTTPStorages/com.imimot.Mitti.*",
    "~/Library/Logs/Mitti",
    "~/Library/Preferences/com.imimot.Mitti.*.plist",
  ]
end