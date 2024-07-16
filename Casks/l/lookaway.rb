cask "lookaway" do
  version "1.6.0"
  sha256 "969585f6e7207ea9df193bb513019a2407846a65fc4573cc4de70ea58e6d38a9"

  url "https:github.commysticalbitslookaway-releasesreleasesdownload#{version}LookAway.dmg",
      verified: "github.commysticalbitslookaway-releases"
  name "LookAway"
  desc "Break time reminder app"
  homepage "https:lookaway.app"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "LookAway.app"

  uninstall quit: "com.mysticalbits.lookaway"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.mysticalbits.lookaway.sfl*",
    "~LibraryApplication SupportLookAway",
    "~LibraryCachesSentryCrashLookAway",
    "~LibraryPreferencescom.mysticalbits.lookaway.plist",
  ]
end