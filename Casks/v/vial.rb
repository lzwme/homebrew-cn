cask "vial" do
  version "0.7.3"
  sha256 "2479ceef2b30f6404962c5bed0d863758c519b7829d755e804ebeb5054689d1d"

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