cask "cozy-drive" do
  version "3.43.0"
  sha256 "6512f3e479819815dd31aff380092286cdebac66a0e1dd01fff1ffc85c05a697"

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