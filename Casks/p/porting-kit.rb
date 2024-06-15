cask "porting-kit" do
  version "6.3.2"
  sha256 "0fea1bbd36bea3c115bc8a94a0ae9afe982a44d824c09cb0d940603f2e0e1a04"

  url "https:github.comvitor251093porting-kit-releasesreleasesdownloadv#{version}Porting-Kit-#{version}.dmg",
      verified: "github.comvitor251093porting-kit-releases"
  name "Porting Kit"
  desc "Install games and apps compiled for Microsoft Windows"
  homepage "https:portingkit.com"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Porting Kit.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.paulthetall.portingkit.sfl*",
    "~LibraryApplication Supportportingkit",
    "~LibraryPreferencescom.paulthetall.portingkit.plist",
    "~LibrarySaved Application Statecom.paulthetall.portingkit.savedState",
  ]
end