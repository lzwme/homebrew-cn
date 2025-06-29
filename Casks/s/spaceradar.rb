cask "spaceradar" do
  version "5.1.0"
  sha256 "af9fdbaf96658cb990f45a76183ca1ce91184d5a91e78676aa57095c9906a06d"

  url "https:github.comzz85space-radarreleasesdownloadv#{version}SpaceRadar-darwin-x64.zip"
  name "SpaceRadar"
  desc "Disk space and memory visualiser"
  homepage "https:github.comzz85space-radar"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "SpaceRadar.app"

  uninstall quit: "com.electron.spaceradar"

  zap trash: [
    "~LibraryApplication Supportspace-radar",
    "~LibraryCachesspace-radar",
    "~LibraryPreferencescom.electron.spaceradar.plist",
    "~LibrarySaved Application Statecom.electron.spaceradar.savedState",
  ]

  caveats do
    requires_rosetta
  end
end