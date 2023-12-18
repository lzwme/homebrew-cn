cask "porting-kit" do
  version "6.0.19"
  sha256 "94bc5f733107950ff6f50f28900d004e2841e178cf82a57c3a2093e3681cb2d6"

  url "https:github.comvitor251093porting-kit-releasesreleasesdownloadv#{version}Porting-Kit-#{version}.dmg",
      verified: "github.comvitor251093porting-kit-releases"
  name "Porting Kit"
  desc "Install games and apps compiled for Microsoft Windows"
  homepage "https:portingkit.com"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Porting Kit.app"

  zap trash: [
    "~LibraryPreferencescom.paulthetall.portingkit.plist",
    "~LibrarySaved Application Statecom.paulthetall.portingkit.savedState",
  ]
end