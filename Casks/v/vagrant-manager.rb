cask "vagrant-manager" do
  version "2.7.1"
  sha256 "ad10795f36a2c0977ec8e278082f1f66624cc3b16f837dc72c0f1c063fefb4de"

  url "https:github.comlanayotechvagrant-managerreleasesdownload#{version}vagrant-manager-#{version}.dmg",
      verified: "github.comlanayotechvagrant-manager"
  name "Vagrant Manager"
  homepage "https:www.vagrantmanager.com"

  app "Vagrant Manager.app"

  uninstall quit: "lanayo.Vagrant-Manager"

  zap trash: [
    "~LibraryCacheslanayo.Vagrant-Manager",
    "~LibraryPreferenceslanayo.Vagrant-Manager.plist",
  ]
end