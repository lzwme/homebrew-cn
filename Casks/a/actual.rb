cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "26.5.0"
  sha256 arm:   "3e4c7c60af347fcfd8ff0e2cbd074d9e2f74c6fbc3735d0a0a15a647b26d6030",
         intel: "e4b99905c176efc649e5130c8d478158120d3521e32f4cd406979c9e17a9b52d"

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