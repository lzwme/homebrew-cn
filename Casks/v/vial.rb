cask "vial" do
  version "0.7.2"
  sha256 "e264988f020b8dc06f8e40dbea25025f45c23192e9cf8398dcf5658b3b5de8c6"

  url "https:github.comvial-kbvial-guireleasesdownloadv#{version}Vial-v#{version}.dmg",
      verified: "github.comvial-kbvial-gui"
  name "Vial"
  desc "Configurator of compatible keyboards in real time"
  homepage "https:get.vial.today"

  app "Vial.app"

  zap trash: [
    "~LibraryApplication SupportVial",
    "~LibraryCachesVial",
    "~LibraryPreferencescom.vial.Vial.plist",
    "~LibraryPreferencesVial.plist",
  ]

  caveats do
    requires_rosetta
  end
end