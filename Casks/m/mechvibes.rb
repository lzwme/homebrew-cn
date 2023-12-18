cask "mechvibes" do
  version "2.3.4"
  sha256 "ba1d345a8c1eb7ff9445e0621b2a9bd2e051a2e92541323dde5d4051f78acef0"

  url "https:github.comhainguyents13mechvibesreleasesdownloadv#{version}Mechvibes-#{version}.dmg",
      verified: "github.comhainguyents13mechvibes"
  name "Mechvibes"
  desc "Play mechanical keyboard sounds as you type"
  homepage "https:mechvibes.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Mechvibes.app"

  zap trash: [
        "~LibraryApplication SupportMechvibes",
        "~LibraryPreferencescom.electron.mechvibes.plist",
        "~LibrarySaved Application Statecom.electron.mechvibes.savedState",
      ],
      rmdir: "~mechvibes_custom"
end