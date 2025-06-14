cask "porting-kit" do
  version "6.5.0"
  sha256 "e3c7fc05e865669671d2d99c4da932ffafad4b7a1835130a3bdb753647259e5d"

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

  caveats do
    requires_rosetta
  end
end