cask "porting-kit" do
  version "6.4.3"
  sha256 "d07a331afe33eb682f2ce9509e7ae4d2d501835b86009ba57d27e033e2df215d"

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