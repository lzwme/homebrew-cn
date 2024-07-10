cask "cozy-drive" do
  version "3.39.0"
  sha256 "8e6a36525aa9423d8269177aa8221d6e2e5b0f1ae05837880823999397810a97"

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