cask "ha-menu" do
  version "2.7.1"
  sha256 "762d0f68ca71aff675df74f3aa6ffb03580dadc6e37ee880ba8c9284a8d1b9b2"

  url "https:github.comcodechimp-orgha-menureleasesdownload#{version}HA.Menu.zip"
  name "HA Menu"
  desc "Menu Bar app to perform common Home Assistant functions"
  homepage "https:github.comcodechimp-orgha-menu"

  depends_on macos: ">= :high_sierra"

  app "HA Menu.app"

  uninstall launchctl: "org.codechimp.HA-Menu",
            quit:      "org.codechimp.HA-Menu"

  zap trash: [
    "~LibraryApplication Scriptsorg.codechimp.HA-Menu",
    "~LibraryApplication Scriptsorg.codechimp.HA-Menu-Launcher",
    "~LibraryContainersorg.codechimp.HA-Menu",
    "~LibraryContainersorg.codechimp.HA-Menu-Launcher",
  ]
end