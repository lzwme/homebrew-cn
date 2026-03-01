cask "loginputmac" do
  version "3.5.8,16051"
  sha256 "cb6645ace37492c7d4d2315d192e87ec8a9d5140db93f20b3fd2119a3cb5f2a7"

  url "https://loginput-mac2.totest.top/LogInputMac#{version.csv.first.major}.app#{version.csv.second}.zip",
      verified: "loginput-mac2.totest.top/"
  name "LoginputMac"
  desc "Chinese input method"
  homepage "https://im.logcg.com/loginputmac#{version.major}"

  livecheck do
    url "https://im.logcg.com/appcast#{version.major}.xml"
    strategy :sparkle
  end

  auto_updates true

  app "LogInputMac#{version.csv.first.major}.app"

  uninstall quit: "com.logcg.inputmethod.LogInputMac#{version.major}"

  zap trash: [
    "~/Documents/落格输入法",
    "~/Library/Application Support/com.logcg.inputmethod.LogInputMac#{version.major}",
    "~/Library/Application Support/LogInputMac#{version.major}",
    "~/Library/Caches/com.logcg.inputmethod.LogInputMac#{version.major}",
    "~/Library/HTTPStorages/com.logcg.inputmethod.LogInputMac#{version.major}",
    "~/Library/Preferences/com.logcg.inputmethod.LogInputMac#{version.major}.plist",
    "~/Library/Saved Application State/com.logcg.inputmethod.LogInputMac#{version.major}.Settings.savedState",
  ]
end