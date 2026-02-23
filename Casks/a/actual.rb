cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "26.2.1"
  sha256 arm:   "e13aa66ee4b86710d5c7f6419d186a2c57a84fa899784dc5ffd1aca4c06b925d",
         intel: "0325440f174463c15c44465bf2686290a64ec297c0941c09997d848878513db2"

  url "https://ghfast.top/https://github.com/actualbudget/actual/releases/download/v#{version}/Actual-mac-#{arch}.dmg",
      verified: "github.com/actualbudget/actual/"
  name "Actual"
  desc "Privacy-focused app for managing your finances"
  homepage "https://actualbudget.org/"

  depends_on macos: ">= :monterey"

  app "Actual.app"

  zap trash: [
    "~/Documents/Actual",
    "~/Library/Application Support/Actual",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.actualbudget.actual.sfl*",
    "~/Library/Logs/Actual",
    "~/Library/Preferences/com.actualbudget.actual.plist",
    "~/Library/Saved Application State/com.actualbudget.actual.savedState",
  ]
end