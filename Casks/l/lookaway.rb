cask "lookaway" do
  version "1.7.1"
  sha256 "fcfd5b7725b9adc8cba8ca6e67b86878e18096abe8db6f330b608a3bb6588771"

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