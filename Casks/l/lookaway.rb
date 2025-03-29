cask "lookaway" do
  version "1.11.1"
  sha256 "06ee241f1cab59d9242b931924eab1ad725abe1e7194da0a616ca52be12d3b24"

  url "https:github.commysticalbitslookaway-releasesreleasesdownload#{version}LookAway.dmg",
      verified: "github.commysticalbitslookaway-releases"
  name "LookAway"
  desc "Break time reminder app"
  homepage "https:lookaway.app"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "LookAway.app"

  uninstall quit: "com.mysticalbits.lookaway"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.mysticalbits.lookaway.sfl*",
    "~LibraryApplication SupportLookAway",
    "~LibraryCachesSentryCrashLookAway",
    "~LibraryPreferencescom.mysticalbits.lookaway.plist",
  ]
end