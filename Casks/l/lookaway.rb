cask "lookaway" do
  version "1.6.1"
  sha256 "e060a0ce1a2cc96b4ba4b52f432044755a3b880db995b9406e2b159c30da82a2"

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