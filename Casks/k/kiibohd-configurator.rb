cask "kiibohd-configurator" do
  version "1.1.0"
  sha256 "996abcfd4f05420199e0302be50d9e878bd28bb50f541b5f6886a1654862e20f"

  url "https:github.comkiibohdconfiguratorreleasesdownloadv#{version}kiibohd-configurator-#{version}-mac.dmg",
      verified: "github.comkiibohdconfigurator"
  name "Kiibohd Configurator"
  desc "Modular community keyboard firmware"
  homepage "https:kiibohd.com"

  depends_on formula: "dfu-util"

  app "Kiibohd Configurator.app"

  uninstall quit: "club.input.KiibohdConfigurator"

  zap trash: [
    "~LibraryApplication Supportkiibohd-configurator",
    "~LibraryLogsKiibohd Configurator",
    "~LibraryPreferencesclub.input.KiibohdConfigurator.plist",
    "~LibrarySaved Application Stateclub.input.KiibohdConfigurator.savedState",
  ]
end