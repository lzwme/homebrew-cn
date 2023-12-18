cask "vial" do
  version "0.7.1"
  sha256 "ca26e97c22495236e7eda5549e10be61ea1dc79211be31899262a75460e038c8"

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
end