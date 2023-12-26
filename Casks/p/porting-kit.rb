cask "porting-kit" do
  version "6.0.21"
  sha256 "c35b00f86c19de4106aeeba0a8066d627f0a01743811a46c7ece66843fadc82b"

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