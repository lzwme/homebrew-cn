cask "sonarr-menu" do
  version "3.3"
  sha256 "627c7df205e0914209a39c17f6a05756a37c5c96232f4dfc3e198219aa05762d"

  url "https:github.comjefbarnSonarr-Menureleasesdownloadv#{version}Sonarr-Menu.v#{version}.zip"
  name "Sonarr Menu"
  desc "Utility that adds a menu to the Status Bar for managing Sonarr"
  homepage "https:github.comjefbarnSonarr-Menu"

  disable! date: "2024-12-16", because: :discontinued

  depends_on cask: "sonarr"

  app "Sonarr-Menu.app"

  uninstall launchctl: "tv.sonarr.Sonarr-Menu",
            quit:      "tv.sonarr.Sonarr-Menu"
end