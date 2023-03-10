cask "houseparty" do
  version "1.14.6,4707"
  sha256 :no_check

  url "https://houseparty-mac-builds.s3.amazonaws.com/Houseparty.dmg",
      verified: "houseparty-mac-builds.s3.amazonaws.com/"
  name "Houseparty"
  desc "Face-to-face social networking app"
  homepage "https://houseparty.com/"

  app "Houseparty.app"

  zap trash: [
    "~/Library/Application Support/com.herzick.mac",
    "~/Library/Caches/com.herzick.mac",
    "~/Library/Preferences/Houseparty.plist",
    "~/Library/Preferences/HousepartyAnalytics.plist",
    "~/Library/Preferences/com.herzick.mac.plist",
  ]
end