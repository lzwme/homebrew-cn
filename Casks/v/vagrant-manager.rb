cask "vagrant-manager" do
  version "2.7.1"
  sha256 "ad10795f36a2c0977ec8e278082f1f66624cc3b16f837dc72c0f1c063fefb4de"

  url "https://ghfast.top/https://github.com/lanayotech/vagrant-manager/releases/download/#{version}/vagrant-manager-#{version}.dmg",
      verified: "github.com/lanayotech/vagrant-manager/"
  name "Vagrant Manager"
  homepage "https://www.vagrantmanager.com/"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Vagrant Manager.app"

  uninstall quit: "lanayo.Vagrant-Manager"

  zap trash: [
    "~/Library/Caches/lanayo.Vagrant-Manager",
    "~/Library/Preferences/lanayo.Vagrant-Manager.plist",
  ]

  caveats do
    requires_rosetta
  end
end