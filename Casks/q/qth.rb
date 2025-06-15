cask "qth" do
  version "0.8.14"
  sha256 "52b41561eb2cfd80a59b3df69787a2b21d22e4fd855ce85b9a9df9f9aeaabe88"

  url "https://www.w8wjb.com/qth/QTH-#{version}.dmg"
  name "QTH"
  desc "APRS client application"
  homepage "https://www.w8wjb.com/wp/qth/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-02-24", because: :moved_to_mas

  depends_on macos: ">= :high_sierra"

  app "QTH.app"

  zap trash: [
    "~/Library/Application Support/com.w8wjb.QTH",
    "~/Library/Caches/com.apple.helpd/Generated/com.w8wjb.QTH.help*",
    "~/Library/Logs/com.w8wjb.QTH",
    "~/Library/Preferences/com.w8wjb.QTH.plist",
  ]
end