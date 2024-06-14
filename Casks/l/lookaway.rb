cask "lookaway" do
  version "1.5.5"
  sha256 "073d8da25eb8c866cbea131166b8ced8cde309179f574840a8172e15727122b4"

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