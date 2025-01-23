cask "cozy-drive" do
  version "3.42.0"
  sha256 "f69f9575a842f473d22a3669ff418f729a2ca092c109983ba084dddad1d4648b"

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