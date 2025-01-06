cask "cozy-drive" do
  version "3.41.0"
  sha256 "5ba318c2851535ec2f3d7acafbd21a2b5537f38f0f5782e0864fcc407f69a297"

  url "https:github.comcozy-labscozy-desktopreleasesdownloadv#{version}Cozy-Drive-#{version}.dmg",
      verified: "github.comcozy-labscozy-desktop"
  name "Cozy Drive"
  desc "File synchronisation for Cozy Cloud"
  homepage "https:cozy.io"

  livecheck do
    url "https:nuts.cozycloud.ccdownloadchannelstableosx"
    strategy :header_match
  end

  depends_on macos: ">= :catalina"

  app "Cozy Drive.app"

  zap trash: [
    "~.cozy-desktop",
    "~LibraryApplication SupportCozy Drive",
    "~LibraryPreferencesio.cozy.desktop.plist",
    "~LibrarySaved Application Stateio.cozy.desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end