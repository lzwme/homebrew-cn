cask "cozy-drive" do
  version "3.40.0"
  sha256 "59c2900d8d8e6696c2a103e39292872ca343f5e0a0b835489560764e2c54294c"

  url "https:github.comcozy-labscozy-desktopreleasesdownloadv#{version}Cozy-Drive-#{version}.dmg",
      verified: "github.comcozy-labscozy-desktop"
  name "Cozy Drive"
  desc "File synchronisation for Cozy Cloud"
  homepage "https:cozy.io"

  livecheck do
    url "https:nuts.cozycloud.ccdownloadchannelstableosx"
    strategy :header_match
  end

  depends_on macos: ">= :sierra"

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